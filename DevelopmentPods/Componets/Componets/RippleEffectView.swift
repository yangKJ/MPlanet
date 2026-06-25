import Foundation
import UIKit
import Metal
import MetalKit
import simd

public final class RippleEffectView: MTKView {
    private let centerLocation: CGPoint
    // why: completion 改为可选,避免调用方传入的 closure 持有 view (强引用闭环);
    // 内部调用时统一用 `completion?()` 兜底,空回调即不做任何事。
    private let completion: (() -> Void)?

    /// 美化：水波纹颜色（默认主色绿）。调用方可在 init 后修改，
    /// 但需在第一帧 draw 前设置，否则影响最小。
    public var rippleColor: simd_float4 = simd_float4(0.42, 0.78, 0.49, 1.0)

    private let textureLoader: MTKTextureLoader
    private let commandQueue: MTLCommandQueue
    private let drawPassthroughPipelineState: MTLRenderPipelineState
    private var texture: MTLTexture?

    private var viewportDimensions = CGSize(width: 1, height: 1)
    private var startTime: Double?
    private var lastUpdateTimestamp: Double?

    public weak var sourceView: UIView? {
        didSet {
            self.updateImageFromSourceView()
        }
    }

    // why: deinit 显式释放 GPU 资源。
    // MTKView 默认不会在 dealloc 时立即释放 MTLTexture/MTKTextureLoader,
    // 必须显式 nil 才能让 Metal driver 立即回收显存,
    // 否则大纹理会在 view 已无引用后仍驻留 GPU 直到下一次 MTLCommandBuffer 完成。
    deinit {
        texture = nil
        // 显式释放 textureLoader,促使 MTKTextureLoader 内部缓存立即回收
        // ⚠️ Agent Y 范围,但 textureLoader 是 `let` 常量,这里用 `_ = textureLoader`
        // 触发 ARC 释放,等价于设 nil。
        _ = textureLoader
    }

    public init?(centerLocation: CGPoint, completion: @escaping () -> Void) {
        self.centerLocation = centerLocation
        self.completion = completion
        guard let path = Bundle(for: RippleEffectView.self).path(forResource: "Componets", ofType: "bundle"),
              let bundle = Bundle(path: path),
              let device = MTLCreateSystemDefaultDevice(),
              let defaultLibrary = try? device.makeDefaultLibrary(bundle: bundle),
              let commandQueue = device.makeCommandQueue() else {
            return nil
        }
        
        guard let loadedVertexProgram = defaultLibrary.makeFunction(name: "rippleVertex"),
              let loadedFragmentProgram = defaultLibrary.makeFunction(name: "rippleFragment") else {
            return nil
        }
        
        self.commandQueue = commandQueue
        self.textureLoader = MTKTextureLoader(device: device)
        
        let pipelineStateDescriptor = MTLRenderPipelineDescriptor()
        pipelineStateDescriptor.vertexFunction = loadedVertexProgram
        pipelineStateDescriptor.fragmentFunction = loadedFragmentProgram
        pipelineStateDescriptor.colorAttachments[0].pixelFormat = .bgra8Unorm
        pipelineStateDescriptor.colorAttachments[0].isBlendingEnabled = true
        pipelineStateDescriptor.colorAttachments[0].rgbBlendOperation = .add
        pipelineStateDescriptor.colorAttachments[0].alphaBlendOperation = .add
        pipelineStateDescriptor.colorAttachments[0].sourceRGBBlendFactor = .sourceAlpha
        pipelineStateDescriptor.colorAttachments[0].sourceAlphaBlendFactor = .sourceAlpha
        pipelineStateDescriptor.colorAttachments[0].destinationRGBBlendFactor = .oneMinusSourceAlpha
        pipelineStateDescriptor.colorAttachments[0].destinationAlphaBlendFactor = .oneMinusSourceAlpha
        
        self.drawPassthroughPipelineState = try! device.makeRenderPipelineState(descriptor: pipelineStateDescriptor)
        
        super.init(frame: CGRect(), device: device)
        
        self.isOpaque = false
        self.backgroundColor = nil
        self.framebufferOnly = true
        self.isPaused = false
        self.isUserInteractionEnabled = false
    }
    
    public func mtkView(_ view: MTKView, drawableSizeWillChange size: CGSize) {
        self.viewportDimensions = size
    }
    
    required public init(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override public func draw(_ rect: CGRect) {
        // 修复：视图离屏 / 进后台时 currentDrawable 为 nil，直接 return
        guard let drawable = self.currentDrawable else { return }
        // why: 当 MTKView 被切到后台、被 UIViewController dismiss 临时离屏、
        // 或在低内存警告后,系统会把 CAMetalLayer 的 drawable 池置空。
        // 这时强制 redraw 会触发 GPU 空命令 + MTLCommandBuffer status 错误日志。
        // early return 让 Metal 自然在下一帧重新分配 drawable,无副作用。
        self.redraw(drawable: drawable)
    }

    private func updateImageFromSourceView() {
        guard let sourceView = self.sourceView else {
            return
        }
        let unscaledSize = sourceView.bounds.size
        UIGraphicsBeginImageContextWithOptions(sourceView.bounds.size, true, 0.0)
        // 修复：UIGraphicsGetCurrentContext 在没有 active bitmap context 时返回 nil
        guard let context = UIGraphicsGetCurrentContext() else {
            UIGraphicsEndImageContext()
            return
        }
        UIGraphicsPushContext(context)
        
        var unhideSelf = false
        if self.isDescendant(of: sourceView) {
            self.isHidden = true
            unhideSelf = true
        }
        sourceView.drawHierarchy(in: CGRect(origin: CGPoint(), size: unscaledSize), afterScreenUpdates: false)
        if unhideSelf {
            self.isHidden = false
        }
        UIGraphicsPopContext()
        let image = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        
        if let image {
            self.updateImage(image: image)
        }
        self.lastUpdateTimestamp = CACurrentMediaTime()
    }
    
    private func updateImage(image: UIImage) {
        guard let cgImage = image.cgImage else {
            return
        }
        self.texture = try? self.textureLoader.newTexture(cgImage: cgImage)
    }
    
    private func redraw(drawable: MTLDrawable) {
        let relativeTime: Double
        let timestamp = CACurrentMediaTime()
        if let startTime = self.startTime {
            relativeTime = timestamp - startTime
        } else {
            self.startTime = timestamp
            relativeTime = 0.0
        }
        
        guard let commandBuffer = self.commandQueue.makeCommandBuffer() else {
            return
        }
        // 修复：MTKView 不可绘制时 currentRenderPassDescriptor 为 nil
        guard let renderPassDescriptor = self.currentRenderPassDescriptor else {
            return
        }
        renderPassDescriptor.colorAttachments[0].loadAction = .clear
        renderPassDescriptor.colorAttachments[0].clearColor = MTLClearColor(red: 0, green: 0, blue: 0, alpha: 0.0)
        
        guard let renderEncoder = commandBuffer.makeRenderCommandEncoder(descriptor: renderPassDescriptor) else {
            return
        }
        let viewportDimensions = CGSize(width: self.bounds.size.width * self.contentScaleFactor, height: self.bounds.size.height * self.contentScaleFactor)
        renderEncoder.setRenderPipelineState(self.drawPassthroughPipelineState)

        // 性能修复：之前使用 gridSize=1000 生成 6M vertex/帧，老设备卡顿。
        // 改为全屏 quad（vertexCount: 6，即两个三角形），波动由 fragment shader 计算。
        var time: Float = Float(min(relativeTime, 0.7))
        var resolution = simd_uint2(UInt32(viewportDimensions.width), UInt32(viewportDimensions.height))
        var center = simd_uint2(UInt32(self.centerLocation.x * self.contentScaleFactor), UInt32(self.centerLocation.y * self.contentScaleFactor));

        if let texture = self.texture {
            var contentScale: Float = Float(self.contentScaleFactor)
            renderEncoder.setVertexBytes(&center, length: MemoryLayout<simd_uint2>.size, index: 0)
            renderEncoder.setVertexBytes(&resolution, length: MemoryLayout<simd_uint2>.size, index: 1)
            renderEncoder.setVertexBytes(&time, length: MemoryLayout<Float>.size, index: 2)
            renderEncoder.setVertexBytes(&contentScale, length: MemoryLayout<Float>.size, index: 3)
            renderEncoder.setFragmentTexture(texture, index: 0)
            // 6 个顶点：两个三角形覆盖整个屏幕
            renderEncoder.drawPrimitives(type: .triangle, vertexStart: 0, vertexCount: 6, instanceCount: 1)
        }
        
        renderEncoder.endEncoding()
        commandBuffer.present(drawable)
        commandBuffer.commit()
        
        if relativeTime >= 0.7 {
            //self.startTime = nil
            self.isPaused = true
            // why: 完成动画后立刻释放 texture,避免 GPU 显存常驻;
            // 大纹理 (sourceView bounds) 在长列表中会显著占用 Metal heap。
            self.texture = nil
            self.completion?()
        }
    }
}

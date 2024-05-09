//
//  ImageXOptions.swift
//  ImageX
//
//  Created by Condy on 2023/2/28.
//

import Foundation
import Harbeth

public typealias ResizingMode = Harbeth.ResizingMode

/// Other parameters related to animated images playback.
/// Represents creating options used in ImageX.
public struct ImageXOptions {
    
    public static var `default` = ImageXOptions()
    
    /// Additional parameters that need to be set to play animated images.
    public var Animated: ImageXOptions.Animated = ImageXOptions.Animated.init()
    
    /// Download additional parameters that need to be configured to download network resources.
    public var Network: ImageXOptions.Network = ImageXOptions.Network.init()
    
    /// Caching data from the web need to be configured parameters.
    public var Cache: ImageXOptions.Cache = ImageXOptions.Cache.init()
    
    /// Appoint the decode or encode coder.
    public var appointCoder: ImageCodering?
    
    /// Placeholder image. default gray picture.
    public var placeholder: ImageX.Placeholder = .none
    
    /// Content mode used for resizing the frame image.
    /// When this property is `original`, modifying the thumbnail pixel size will not work.
    public var resizingMode: ImageX.ResizingMode = .original
    
    /// Whether or not to generate the thumbnail images.
    /// Defaults to CGSizeZero, Then take the size of the displayed control size as the thumbnail pixel size.
    public var thumbnailPixelSize: CGSize = .zero
    
    /// Harbeth filters apply to image or gif frame.
    public var filters: [C7FilterProtocol] = []
    
    /// 做组件化操作时刻，解决本地GIF或本地图片所处于另外模块从而读不出数据问题。😤
    /// Do the component operation to solve the problem that the local GIF or Image cannot read the data in another module.
    public let moduleName: String
    
    /// Instantiation of configuration parameters.
    /// - Parameters:
    ///   - moduleName: Do the component operation to solve the problem that the local GIF or image cannot read the data in another module.
    public init(moduleName: String = "ImageX") {
        self.moduleName = moduleName
    }
    
    /// 防止重复设置占位信息
    private var displayed: Bool = false
}

extension ImageXOptions {
    
    /// Set up decoder parameters
    func setupDecoderOptions(finished: Bool) -> ImageCodering.ImageCoderOptions {
        return [
            CoderOptions.decoder.frameTypeKey : self.Animated.frameType,
            CoderOptions.decoder.thumbnailPixelSizeKey : self.thumbnailPixelSize,
            CoderOptions.decoder.resizingModeKey : self.resizingMode,
            CoderOptions.decoder.filtersKey : self.filters,
            CoderOptions.decoder.completeDataKey : finished,
        ] as ImageCodering.ImageCoderOptions
    }
    
    func mutating(_ block: (inout ImageXOptions) -> Void) -> ImageXOptions {
        var options = self
        block(&options)
        return options
    }
    
    @discardableResult func setPlaceholder(to view: AsAnimatable, other: Others?) -> ImageXOptions {
        if self.displayed {
            return self
        }
        DispatchQueue.main.async {
            self.placeholder.display(to: view, resizingMode: self.resizingMode, other: other)
        }
        return self.mutating({
            $0.displayed = true
        })
    }
    
    func removeViewPlaceholder(form view: AsAnimatable?, other: Others?) {
        guard let view = view else {
            return
        }
        switch self.placeholder {
        case .view:
            DispatchQueue.main.async {
                self.placeholder.remove(from: view, other: other)
            }
        default:
            break
        }
    }
    
    /// Fixed the setting  `options.resizingMode` attributes cannot be filled.
    func setViewContentMode(to view: AsAnimatable) -> ImageXOptions {
        if self.resizingMode == .original {
            return self
        }
        #if canImport(UIKit)
        view.contentMode = .scaleAspectFit
        #endif
        if self.thumbnailPixelSize == .zero {
            let realsize = Driver.realViewFrame(to: view).size
            return self.mutating({
                $0.thumbnailPixelSize = realsize
            })
        }
        return self
    }
    
    func fetchDecoder(data: Data?) -> ImageCodering? {
        guard let data = data else {
            return nil
        }
        var coder: ImageCodering?
        if let appointCoder = appointCoder {
            coder = appointCoder
        } else {
            let format = AssetType(data: data)
            switch format {
            case .jpeg:
                coder = ImageJPEGCoder.init(data: data)
            case .png:
                coder = AnimatedAPNGCoder.init(data: data)
            case .gif:
                coder = AnimatedGIFsCoder.init(data: data)
            case .webp:
                coder = AnimatedWebPCoder.init(data: data)
            case .heif, .heic:
                coder = AnimatedHEICCoder.init(data: data, format: format)
            case .tiff, .raw, .pdf, .bmp, .svg:
                coder = ImageIOCoder.init(data: data, format: format)
            default:
                return nil
            }
        }
        coder?.data = data
        coder?.setupImageSource(data: data)
        return coder
    }
}

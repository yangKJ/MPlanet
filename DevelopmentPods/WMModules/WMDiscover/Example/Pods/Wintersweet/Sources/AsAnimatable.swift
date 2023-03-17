//
//  AsAnimatable.swift
//  Wintersweet
//
//  Created by Condy on 2023/1/5.
//  Reference source See: https://github.com/kean/Nuke/tree/master/Sources/NukeUI/Gifu

import Foundation
import Harbeth

public typealias TimeInterval = Foundation.TimeInterval

/// The protocol that view classes need to conform to to enable animated GIF support.
public protocol AsAnimatable: HasAnimatable {
    
    /// Total duration of one animation loop.
    var loopDuration: TimeInterval { get }
    
    /// The first frame that is not nil of GIF.
    var fristFrame: C7Image? { get }
    
    /// Returns the active frame if available.
    var activeFrame: C7Image? { get }
    
    /// Total frame count of the GIF.
    var frameCount: Int { get }
    
    /// Introspect whether the instance is animating.
    var isAnimatingGIF: Bool { get }
    
    /// Bitmap memory cost with bytes.
    var costGIF: Int { get }
    
    /// Stop animating and free up GIF data from memory.
    func prepareForReuseGIF()
    
    /// Start animating GIF.
    func startAnimatingGIF()
    
    /// Stop animating GIF.
    func stopAnimatingGIF()
    
    /// Prepare for animation and start play GIF.
    /// - Parameters:
    ///   - data: gif data.
    ///   - filters: Harbeth filters apply to image or gif frame.
    ///   - options: Represents gif playback creating options used in Wintersweet.
    func play(data: Data?, filters: [C7FilterProtocol], options: AnimatedOptions)
}

extension AsAnimatable {
    /// Prepare for animation and start play GIF.
    public func play(data: Data?, filters: [C7FilterProtocol], options: AnimatedOptions) {
        if options.displayed == false {
            options.placeholder.display(to: self, contentMode: options.contentMode)
        }
        guard let data = data, AssetType(data: data) == .gif else { return }
        let frameStore = FrameStore(data: data,
                                    filters: filters,
                                    size: frame.size,
                                    framePreloadCount: options.bufferCount,
                                    contentMode: options.contentMode,
                                    loopCount: options.loop.count)
        frameStore.prepareFrames { [weak self] in
            guard let `self` = self else { return }
            if case .fristFrame = options.loop {
                if let frame = frameStore.animatedFrames.compactMap({ $0.image }).first {
                    options.placeholder.remove(from: self)
                    self.setContentImage(frame)
                }
            } else if case .lastFrame = options.loop {
                if let frame = frameStore.animatedFrames.compactMap({ $0.image }).last {
                    options.placeholder.remove(from: self)
                    self.setContentImage(frame)
                }
            } else {
                options.placeholder.remove(from: self)
            }
            options.preparation?()
        }
        animator?.frameStore = frameStore
        animator?.animationBlock = options.animated
        switch options.loop {
        case .forever, .never, .count:
            animator?.startAnimating()
        case .fristFrame, .lastFrame:
            animator?.stopAnimating()
        }
    }
}

extension AsAnimatable {
    public var loopDuration: TimeInterval { animator?.frameStore?.loopDuration ?? 0 }
    public var fristFrame: C7Image? { animator?.frameStore?.fristFrame }
    public var activeFrame: C7Image? { animator?.frameStore?.currentFrameImage }
    public var frameCount: Int { animator?.frameStore?.frameCount ?? 0 }
    public var isAnimatingGIF: Bool { animator?.isAnimating ?? false }
    public var costGIF: Int { animator?.frameStore?.cost ?? 0 }
    public func prepareForReuseGIF() { animator?.prepareForReuse() }
    public func startAnimatingGIF() { animator?.startAnimating() }
    public func stopAnimatingGIF() { animator?.stopAnimating() }
}

extension AsAnimatable {
    /// Updates the image with a new frame if necessary.
    func updateImageIfNeeded() {
        guard let activeFrame = activeFrame else {
            return
        }
        setContentImage(activeFrame)
    }
    
    /// Setting up what is currently showing.
    func setContentImage(_ image: C7Image?) {
        if var imageContainer = self as? ImageContainer {
            imageContainer.image = image
        } else {
            #if !os(macOS)
            //self.layer.setNeedsDisplay()
            self.layer.contents = image?.cgImage
            #endif
        }
    }
}

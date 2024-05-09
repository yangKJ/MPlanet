//
//  AsAnimatable.swift
//  ImageX
//
//  Created by Condy on 2023/1/5.
//  Reference source See: https://github.com/kean/Nuke/tree/master/Sources/NukeUI/Gifu

import Foundation
import Harbeth

public typealias TimeInterval = Foundation.TimeInterval

/// The protocol that view classes need to conform to to enable animated images support.
public protocol AsAnimatable: HasAnimatable {
    
    /// Total duration of one animation loop.
    var loopDuration: TimeInterval { get }
    
    /// The first frame that is not nil of animated images.
    var fristFrame: C7Image? { get }
    
    /// Returns the active frame if available.
    var activeFrame: C7Image? { get }
    
    /// Total frame count of the animated images.
    var frameCount: Int { get }
    
    /// Introspect whether the instance is animating.
    var isAnimating: Bool { get }
    
    /// Bitmap memory cost with bytes.
    var cost: Int { get }
    
    /// Stop animating and free up animated images data from memory.
    func prepareForReuse()
    
    /// Start animating animated image.
    func startAnimating()
    
    /// Stop animating animated image.
    func stopAnimating()
    
    /// Prepare for animation and start play animated image.
    /// - Parameters:
    ///   - data: gif data.
    ///   - options: Represents animated image playback creating options used in ImageX.
    func play(data: Data?, options: ImageXOptions)
}

extension AsAnimatable {
    
    public var loopDuration: TimeInterval {
        animator?.frameStore?.loopDuration ?? 0
    }
    
    public var fristFrame: C7Image? {
        animator?.frameStore?.fristFrame
    }
    
    public var activeFrame: C7Image? {
        animator?.frameStore?.currentFrameImage
    }
    
    public var frameCount: Int {
        animator?.frameStore?.frameCount ?? 0
    }
    
    public var isAnimating: Bool {
        animator?.isAnimating ?? false
    }
    
    public var cost: Int {
        animator?.frameStore?.cost ?? 0
    }
    
    public func prepareForReuse() {
        animator?.prepareForReuse()
    }
    
    public func startAnimating() {
        animator?.startAnimating()
    }
    
    public func stopAnimating() {
        animator?.stopAnimating()
    }
    
    public func play(data: Data?, options: ImageXOptions) {
        guard let decoder = options.fetchDecoder(data: data) as? AnimatedCodering else {
            return
        }
        let options = options.setViewContentMode(to: self).setPlaceholder(to: self, other: nil)
        self.setStartPlay(decoder: decoder, options: options, other: nil, prepared: { [weak self] in
            options.removeViewPlaceholder(form: self, other: nil)
        })
    }
}

//
//  Animator.swift
//  Wintersweet
//
//  Created by Condy on 2023/1/5.
//

import Foundation
import QuartzCore
import Harbeth

/// Responsible for parsing GIF data and decoding the individual frames.
final class Animator {
    
    /// A delegate responsible for displaying the GIF frames.
    weak var delegate: AsAnimatable!
    
    var animationBlock: ((_ loopDuration: TimeInterval) -> Void)?
    
    /// Responsible for loading individual frames and resizing them if necessary.
    var frameStore: FrameStore?
    
    /// Tracks whether the display link is initialized.
    private var displayLinkInitialized: Bool = false
    
    /// Responsible for starting and stopping the animation.
    private lazy var displayLink: Harbeth.CADisplayLink = {
        self.displayLinkInitialized = true
        let target = DisplayLinkProxy(target: self)
        let display = Harbeth.CADisplayLink(target: target, selector: #selector(DisplayLinkProxy.onScreenUpdate(_:)))
        //displayLink.add(to: .main, forMode: RunLoop.Mode.common)
        display.add(to: .current, forMode: RunLoop.Mode.default)
        display.isPaused = true
        return display
    }()
    
    /// Creates a new animator with a delegate.
    /// - parameter view: A view object that implements the `AsAnimatable` protocol.
    /// - returns: A new animator instance.
    init(withDelegate delegate: AsAnimatable) {
        self.delegate = delegate
    }
    
    deinit {
        if displayLinkInitialized {
            displayLink.invalidate()
        }
    }
}

extension Animator {
    /// Introspect whether the `displayLink` is paused.
    var isAnimating: Bool {
        get {
            return !displayLink.isPaused
        }
    }
    
    /// Start animating.
    func startAnimating() {
        if frameStore?.isAnimatable ?? false {
            displayLink.isPaused = false
        }
    }
    
    /// Stop animating.
    func stopAnimating() {
        displayLink.isPaused = true
    }
    
    /// Stop animating and nullify the frame store.
    func prepareForReuse() {
        stopAnimating()
        frameStore = nil
    }
}

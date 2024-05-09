//
//  AsAnimatable+SetImg.swift
//  ImageX
//
//  Created by Condy on 2023/7/3.
//

import Foundation
import Harbeth

extension AsAnimatable {
    
    /// Updates the image with a new frame if necessary.
    func updateImageIfNeeded(other: Others?) {
        guard let activeFrame = activeFrame else {
            return
        }
        setContentImage(activeFrame, other: other)
    }
    
    /// Prepare for animation and start play animated images.
    func setStartPlay(decoder: AnimatedCodering, options: ImageXOptions, other: Others?, prepared: @escaping () -> Void) {
        let store = FrameStore(decoder: decoder, options: options) { [weak self] _ in
            DispatchQueue.main.async { prepared() }
            self?.animator?.startAnimating()
        }
        animator?.frameStore = store
        animator?.options = options
        animator?.other = other
        animator?.animationBlock = options.Animated.animated
    }
    
    /// Setting up what is currently showing image.
    @inline(__always) func setContentImage(_ image: C7Image?, other: ImageX.Others?) {
        DispatchQueue.main.async {
            switch self {
            case var container_ as ImageContainer:
                container_.image = image
            #if canImport(AppKit) && !targetEnvironment(macCatalyst)
            case var container_ as NSButtonContainer:
                guard let other = other else {
                    return
                }
                switch Others.NSButtonKey(rawValue: other.key) {
                case .image:
                    container_.image = image
                case .alternateImage:
                    container_.alternateImage = image
                case .none:
                    break
                }
            #endif
            #if canImport(UIKit) && !os(watchOS)
            case var container_ as UIButtonContainer:
                guard let other = other else {
                    return
                }
                switch Others.UIButtonKey(rawValue: other.key) {
                case .image:
                    if let state = other.value as? UIControl.State {
                        container_.setImage(image, for: state)
                        let (_, backImage) = container_.cacheImages[state.rawValue] ?? (nil, nil)
                        container_.cacheImages[state.rawValue] = (image, backImage)
                    }
                case .backgroundImage:
                    if let state = other.value as? UIControl.State {
                        container_.setBackgroundImage(image, for: state)
                        let (image_, _) = container_.cacheImages[state.rawValue] ?? (nil, nil)
                        container_.cacheImages[state.rawValue] = (image_, image)
                    }
                case .none:
                    break
                }
            case var container_ as UIImageViewContainer:
                guard let other = other else {
                    return
                }
                switch Others.UIImageViewKey(rawValue: other.key) {
                case .image:
                    container_.image = image
                case .highlightedImage:
                    container_.highlightedImage = image
                case .none:
                    break
                }
            #endif
            #if canImport(WatchKit)
            case var container_ as WKInterfaceImageContainer:
                container_.image = image
                container_.setImage(image)
            #endif
            default:
                #if os(macOS)
                self.layer?.contents = image?.cgImage
                #else
                //self.layer.setNeedsDisplay()
                self.layer.contents = image?.cgImage
                #endif
            }
        }
    }
}

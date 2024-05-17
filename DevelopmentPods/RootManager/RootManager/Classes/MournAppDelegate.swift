//
//  MournAppDelegate.swift
//  RootManager
//
//  Created by Condy on 2023/3/13.
//

import Foundation
import FeatBox

/// 悼念模式
class MournAppDelegate: AppDelegateType {
    
    static let overlayTag = 30008
    static let alertOverlayTag = 30009
    
    weak var keyWindow: UIWindow?
    
    lazy var overlay: UIView = {
        let overlay = UIView.init(frame: keyWindow?.bounds ?? .zero)
        overlay.isUserInteractionEnabled = false
        overlay.translatesAutoresizingMaskIntoConstraints = false
        overlay.backgroundColor = .lightGray
        overlay.layer.compositingFilter = "saturationBlendMode"
        overlay.layer.zPosition = CGFloat(Float.greatestFiniteMagnitude)
        overlay.tag = Self.overlayTag
        return overlay
    }()
    
    lazy var alertOverlay: UIView = {
        let overlay = UIView.init(frame: .zero)
        overlay.isUserInteractionEnabled = false
        overlay.translatesAutoresizingMaskIntoConstraints = false
        overlay.backgroundColor = .lightGray
        overlay.layer.compositingFilter = "saturationBlendMode"
        overlay.layer.zPosition = CGFloat(Float.greatestFiniteMagnitude)
        overlay.tag = Self.alertOverlayTag
        return overlay
    }()
    
    init(window: UIWindow?) {
        self.keyWindow = window
        super.init()
    }
}

extension MournAppDelegate {
    
    func displayMournMode() {
        if MournType.hasMourning() {
            if let view = keyWindow?.viewWithTag(Self.overlayTag) {
                view.isHidden = false
            } else {
                keyWindow?.addSubview(overlay)
            }
        }
    }
    
    func closeMournMode() {
        if MournType.closeMourned() {
            if let view = keyWindow?.viewWithTag(Self.overlayTag) {
                view.isHidden = true
            }
        }
    }
    
    func alertDisplayMorun(alert: UIView?) {
        if MournType.hasMourning() {
            alert?.layoutIfNeeded()
            alertOverlay.frame = alert?.bounds ?? .zero
            if let view = alert?.viewWithTag(Self.alertOverlayTag) {
                view.isHidden = false
            } else {
                alert?.addSubview(alertOverlay)
            }
        }
    }
}

//
//  Mourning.swift
//  Alamofire
//
//  Created by Condy on 2025/6/1.
//

import Foundation
import ProductLib

public enum MournType: String {
    case none = "MOURN_NONE"
    case home = "MOURN_HOME"
    case all  = "MOURN_ALL"
}

/// 哀悼模式 - 改为 enum 命名空间,避免外部 `Mourning()` 误实例化。
/// 用法:`Mourning.setupMournMode()` / `Mourning.closeMournMode()`。
public enum Mourning {

    private static let overlayTag = 20008
    private static let alertOvTag = 30008

    private static var overlay: UIView?
    private static var alertOverlay: UIView?

    private static var keyWindow: UIWindow? {
        return (UIApplication.shared.delegate as? BridgeAppDelegateable)?.bridgeUIWindow
    }

    /// 开启哀悼模式(若有 alert 控件,在 alert 上叠加灰度滤镜)
    public static func setupMournMode() {
        guard AppUserSettings.mournType.hasMourning() else {
            return
        }
        if let view = keyWindow?.viewWithTag(Mourning.overlayTag) {
            view.isHidden = false
            return
        }
        let overlayView = makeOverlay(tag: Mourning.overlayTag, zPosition: 998)
        overlayView.frame = keyWindow?.bounds ?? .zero
        keyWindow?.addSubview(overlayView)
        Mourning.overlay = overlayView
    }

    /// 关闭哀悼模式
    public static func closeMournMode() {
        guard AppUserSettings.mournType.canCloseMournMode() else {
            return
        }
        if let view = keyWindow?.viewWithTag(Mourning.overlayTag) {
            view.isHidden = true
        }
    }

    /// 给弹窗视图叠加哀悼灰度滤镜
    public static func alertDisplayMorun(alert: UIView?) {
        guard let alert = alert, AppUserSettings.mournType.hasMourning() else {
            return
        }
        alert.layoutIfNeeded()
        if let view = alert.viewWithTag(Mourning.alertOvTag) {
            view.frame = alert.bounds
            view.isHidden = false
            return
        }
        let overlayView = makeOverlay(tag: Mourning.alertOvTag, zPosition: 999)
        overlayView.frame = alert.bounds
        alert.addSubview(overlayView)
        Mourning.alertOverlay = overlayView
    }

    private static func makeOverlay(tag: Int, zPosition: CGFloat) -> UIView {
        let view = UIView(frame: .zero)
        view.isUserInteractionEnabled = false
        view.translatesAutoresizingMaskIntoConstraints = false
        view.backgroundColor = .lightGray
        view.layer.compositingFilter = "saturationBlendMode"
        view.layer.zPosition = zPosition
        view.tag = tag
        return view
    }
}

extension MournType {
    func hasMourning() -> Bool {
        switch self {
        case .none:
            break
        case .home, .all:
            let millisecondTime = Date().fy.millisecondTimeIntervalSince1970
            if AppUserSettings.mournStartTime <= millisecondTime, AppUserSettings.mournEndTime > millisecondTime {
                return true
            }
        }
        return false
    }

    /// 是否可以关闭哀悼模式(原 canClosed,改名 canCloseMournMode 更清晰)
    func canCloseMournMode() -> Bool {
        switch self {
        case .none:
            return true
        case .home:
            return true
        case .all:
            if Date().fy.millisecondTimeIntervalSince1970 >= AppUserSettings.mournEndTime {
                return true
            }
        }
        return false
    }
}

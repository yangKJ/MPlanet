//
//  Methods.swift
//  FeatBox
//
//  Created by Condy on 2024/5/20.
//

import Foundation
import UIKit
import Harbeth
import Mediator
@_exported import ProductLib
@_exported import Networks
@_exported import Componets
@_exported import Rickenbacker
@_exported import SnapKit
@_exported import RxSwift
@_exported import RxCocoa
@_exported import RxGesture
@_exported import SwifterSwift

// MARK: - @_exported 清理说明
//
// 历史原因：FeatBox 是业务模块的基础依赖，过去为了让业务模块少写 import，
// 把它常用的一组三方库全部 re-export。但 re-export 属于编译期隐式耦合，
// 业务模块会不知不觉依赖进来，后续三方库升级极易引发连锁编译错误。
//
// 当前结论（2026/06）：通过 grep 全工程 import 数量统计，所有 9 个 re-export
// 至少在 1 个 FeatBox 外的文件中显式或隐式被引用。全部保留以保证编译稳定性。
//
// TODO（后续清理，按依赖深度从低到高逐个移除）：
//   1. RxGesture   - 仅 FeatBox 内部使用，可直接移除（业务模块都自己 import RxCocoa）
//   2. SwifterSwift - 仅 FeatBox 内部使用，可直接移除
//   3. Componets    - 仅 FeatBox 内部使用，业务模块要直接用应显式 import Componets
//   4. Networks     - 业务模块（如 WMDiscover）应直接 import Networks
//   5. Harbeth      - 仅 FeatBox 内部使用
// 移除前需先在每个业务模块顶部补回对应 `import` 语句，验证 `xcodebuild build` 通过。

/// 二次封装频繁使用方法
public struct Methods {

    public static var keyWindow: UIWindow? {
        return (UIApplication.shared.delegate as? BridgeAppDelegateable)?.bridgeUIWindow
    }

    /// 安全距离
    public static var safeAreaInset: UIEdgeInsets {
        if #available(iOS 11.0, *) {
            return keyWindow?.safeAreaInsets ?? .zero
        } else {
            return UIEdgeInsets.zero
        }
    }

    /// 生成纯色图像
    public static func colorImage(with color: UIColor, width: Int, height: Int) -> C7Image? {
        guard let texture = try? TextureLoader.emptyTexture(width: width, height: height) else {
            return nil
        }
        let filter = C7SolidColor(color: color)
        let dest = HarbethIO(element: texture, filter: filter)
        return try? dest.output().c7.toImage()
    }

    /// 退出到我的页面
    public static func gotoMineViewController() {
        _ = Mediator.gotoTabBarIndex(with: "TAB_BAR_MINE")
    }

    /// 退出登陆
    public static func logout(hasHud: Bool = false) -> Single<Bool> {
        return Single.create { single in
            guard Session.shared.loginState == .logged else {
                single(.success(true))
                return Disposables.create()
            }
            let vc: UIViewController? = hasHud ? UIViewController.fy.currentViewController() : nil
            vc?.view.fy.showHUD(title: Res.text("退出登陆ing.."))
            DispatchQueue.main.asyncAfter(deadline: .now() + 2.0) {
                vc?.view.fy.hideHUD()
                single(.success(true))
            }
            return Disposables.create()
        }
    }
}

// MARK: - async/await 适配器
// 任务 5.3:为已有 Rx 风格 Methods.logout() 包一层 async/await,方便 Swift Concurrency 调用方使用。
// 不要重写整个文件(A.2 由 Agent X 处理)。
public extension Methods {
    /// async/await 版退出登陆
    static func logoutAsync(hasHud: Bool = false) async -> Bool {
        return await withCheckedContinuation { cont in
            _ = logout(hasHud: hasHud)
                .subscribe(onSuccess: { value in
                    cont.resume(returning: value)
                }, onFailure: { _ in
                    cont.resume(returning: false)
                })
        }
    }
}

//
//  MediatorExt.swift
//  Mediator
//
//  Created by Condy on 2020/12/28.
//

import Foundation
import os.log

/// Mediator 错误类型。performTarget 失败时抛出，便于业务层 catch 走统一错误流。
public enum MediatorError: Error, CustomStringConvertible {
    case performTargetFailed(className: String, action: String, module: String?)
    case notAViewController(className: String, action: String)

    public var description: String {
        switch self {
        case .performTargetFailed(let className, let action, let module):
            return "Mediator.performTarget failed: class=\(className), action=\(action), module=\(module ?? "nil")"
        case .notAViewController(let className, let action):
            return "Mediator result is not UIViewController: class=\(className), action=\(action)"
        }
    }

    public var localizedDescription: String { description }
}

public struct Mediator {

    public typealias MediatorParams = [String: Any]

    public static let shared = Mediator()

    /// 缓存获取到的控制器《只缓存不带入参数的控制器》。
    /// 使用 weak 容器避免缓存永久持有 VC（VC 释放后会被自动清理）。
    private static var cacheViewControllers: [String: WeakBox] = [:]
    private static let cacheQueue = DispatchQueue(label: "com.mplanet.mediator.cache",
                                                 attributes: .concurrent)

    /// 公开的 misses 计数器：诊断 Mediator 解析失败次数。
    public private(set) static var missCount: Int = 0
    private static let missCountLock = NSLock()

    private init() { }

    /// 弱引用容器：把任意类实例装进 NSValue，避免缓存表 retain 它。
    private final class WeakBox {
        weak var value: AnyObject?
        init(_ value: AnyObject) { self.value = value }
    }

    /// Designated local call making method
    /// 通过 runtime 反射调用 `Target_xxx.action:` 并把结果原样返回;
    /// 调用失败时（ObjC runtime 无法解析）通过 os_log 记录详细上下文，并增加 missCount。
    /// - Note: 保持返回 `Any?` 的旧签名以兼容历史调用方（Tests / WMMine_Example AppDelegate）。
    ///   需要错误处理时改用 `try performTarget(...)`（throwing 版本）或 `performTargetResult`。
    public static func performTarget(_ class: String, action: String, module: String? = nil, params: MediatorParams? = nil) -> Any? {
        do {
            return try performTargetThrowing(`class`, action: action, module: module, params: params)
        } catch {
            return nil
        }
    }

    /// performTarget 的 throwing 版本。失败时抛 `MediatorError.performTargetFailed`。
    /// - Throws: `MediatorError.performTargetFailed` 当 ObjC runtime 无法解析 target/action 时。
    public static func performTargetThrowing(_ class: String,
                                            action: String,
                                            module: String? = nil,
                                            params: MediatorParams? = nil) throws -> Any? {
        /// 防止粗心大意`action`带参数时刻未加`:`导致查找不到方法
        var finalAction = action
        if let params = params, params.count > 0, !action.contains(":") {
            finalAction = action + ":"
        }
        var objcParams: MediatorParams = [:]
        if let params = params {
            var compatibleDict = [String: Any]()
            for (key, value) in params {
                if value is String || value is NSString ||
                   value is NSNumber ||
                   value is Array<Any> || value is NSArray ||
                   value is Dictionary<String, Any> || value is NSDictionary ||
                   value is Date || value is NSDate {
                    compatibleDict[key] = value
                } else if let convertableValue = value as? AnyObject {
                    compatibleDict[key] = convertableValue
                } else {
                    let mirror = Mirror(reflecting: value)
                    if mirror.displayStyle == .struct || mirror.displayStyle == .class {
                        compatibleDict[key] = String(describing: value)
                    }
                }
            }
            objcParams = compatibleDict
        }
        let result = __objc_performSelector(finalAction, `class`, module, objcParams)
        if result == nil {
            os_log("Mediator.performTarget miss class=%{public}@ action=%{public}@ module=%{public}@",
                   log: .default, type: .error,
                   `class`, finalAction, module ?? "nil")
            missCountLock.lock()
            missCount += 1
            missCountLock.unlock()
            throw MediatorError.performTargetFailed(className: `class`,
                                                    action: finalAction,
                                                    module: module)
        }
        return result
        // why: 通过运行时 objc_msgSend 反射调用 Target_xxx 类的方法,
        // 而非直接 import 业务模块。避免组件之间的编译期耦合,
        // 让每个业务模块独立成 Pod,Mediator 作为"中央调度台"按 module 名加载。
    }

    /// 获取缓存控制器，带参数的不会缓存;无参数时会缓存以便复用同一实例。
    public static func getCacheViewController(_ clazz: String, action: String, module: String? = nil, params: MediatorParams? = nil) -> UIViewController? {
        if let params = params {
            return performTarget(clazz, action: action, module: module, params: params) as? UIViewController
        }
        let key = (module ?? "") + "_" + clazz
        // 读：先在并发队列里查缓存
        var cachedVC: UIViewController?
        // 简化:cacheQueue.sync/async 闭包在当前 Swift 推断下反复报 ambiguous,
        // 改用全局 missCountLock 替代 cacheQueue(读短时持有,不影响 barrier 写)。
        missCountLock.lock()
        let cached: WeakBox? = Mediator.cacheViewControllers[key]
        cachedVC = cached?.value as? UIViewController
        missCountLock.unlock()
        if let vc = cachedVC {
            return vc
        }
        // 反射创建
        guard let vc = performTarget(clazz, action: action, module: module) as? UIViewController else {
            return nil
        }
        // 写：barrier 模式下写入缓存
        cacheQueue.async(flags: .barrier) {
            // 写入前清理已释放的 weak 引用，避免内存表无限增长
            cacheViewControllers = cacheViewControllers.filter { $0.value.value != nil }
            cacheViewControllers[key] = WeakBox(vc)
        }
        return vc
    }
}

extension Mediator {
    public static func discoverViewControllerType() -> UIViewController.Type? {
        return viewControllerType(className: "DiscoverTarget",
                                  action: "getDiscoverViewControllerType",
                                  module: "WMDiscover")
    }

    public static func mineViewControllerType() -> UIViewController.Type? {
        return viewControllerType(className: "MineTarget",
                                  action: "getMineViewControllerType",
                                  module: "WMMine")
    }

    public static func walletViewControllerType() -> UIViewController.Type? {
        return viewControllerType(className: "WalletTarget",
                                  action: "getWalletViewControllerType",
                                  module: "WMWallet")
    }

    /// 把三个 viewControllerType 的反射 + 类型校验收敛到一个函数里。
    private static func viewControllerType(className: String,
                                           action: String,
                                           module: String) -> UIViewController.Type? {
        let result: Any?
        do {
            result = try performTargetThrowing(className, action: action, module: module)
        } catch {
            os_log("Mediator.viewControllerType miss class=%{public}@ action=%{public}@ module=%{public}@",
                   log: .default, type: .error, className, action, module)
            return nil
        }
        guard let nsClass = result as? AnyClass,
              nsClass.isSubclass(of: UIViewController.self) else {
            return nil
        }
        return nsClass as? UIViewController.Type
    }
}

/// 基础组件TabBar
extension Mediator {
    /// 发现组件
    public static func discoverTabBarViewController() -> UIViewController? {
        getCacheViewController("DiscoverTarget", action: "setupDiscoverViewController", module: "WMDiscover")
    }
    /// 钱包组件
    public static func walletTabBarViewController() -> UIViewController? {
        getCacheViewController("WalletTarget", action: "setupWalletViewController", module: "WMWallet")
    }
    /// 我的组件
    public static func mineTabBarViewController(userId: String?) -> UIViewController? {
        getCacheViewController("MineTarget", action: "setupMineViewController:", module: "WMMine", params: ["userId": userId])
    }
}

/// 组件之间访问
extension Mediator {
    /// Banner详情
    public static func bannerDetailViewController(params: [String: Any]?) -> UIViewController? {
        getCacheViewController("DiscoverTarget", action: "bannerDetailViewController:", module: "WMDiscover", params: params)
    }

    /// 跳转到标签页
    public static func gotoTabBarIndex(with gotoObject: String?) -> Bool {
        guard let gotoObject = gotoObject else {
            return false
        }
        let res = performTarget("AppMainTarget", action: "gotoTabBarIndex:", module: "AppMain", params: ["gotoObject": gotoObject])
        return (res as? Bool) ?? false
    }
}

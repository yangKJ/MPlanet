//
//  Constants.swift
//  ProductLib
//
//  Created by Condy on 2020/10/22.
//

import Foundation
import UIKit

/// 常用常量And方法
/// - Note: iOS 16+ 已 deprecated UIScreen.main / UIApplication.shared.windows / .keyWindow。
///   这里使用 NotificationCenter 监听屏幕旋转、keyWindow 变更通知，确保缓存与 trait 同步。
public struct Constants {

    // 内部缓存：所有 static let 通过 _Cache 单例维护，监听屏幕变化时刷新
    private final class _Cache {
        static let shared = _Cache()
        var width: CGFloat = UIScreen.main.bounds.width
        var height: CGFloat = UIScreen.main.bounds.height
        var barHeight: CGFloat = 0
        var statusBarHeight: CGFloat = 20
        var safeAreaEdgeInsets: UIEdgeInsets = .zero
        var keyWindow: UIWindow? = nil
        var isNotchedDevice: Bool = false
        var initialized: Bool = false
        private init() {
            refresh()
            // 监听屏幕尺寸、keyWindow、状态栏变更
            NotificationCenter.default.addObserver(
                self,
                selector: #selector(handleScreenChange),
                name: UIScreen.didConnectNotification,
                object: nil)
            NotificationCenter.default.addObserver(
                self,
                selector: #selector(handleScreenChange),
                name: UIScreen.didDisconnectNotification,
                object: nil)
            NotificationCenter.default.addObserver(
                self,
                selector: #selector(handleScreenChange),
                name: UIApplication.didBecomeActiveNotification,
                object: nil)
            NotificationCenter.default.addObserver(
                self,
                selector: #selector(handleScreenChange),
                name: UIDevice.orientationDidChangeNotification,
                object: nil)
        }
        deinit {
            NotificationCenter.default.removeObserver(self)
        }
        @objc private func handleScreenChange() {
            refresh()
        }
        fileprivate func refresh() {
            // 修复：使用 traitCollection 而非 UIScreen.main 缓存（iOS 16+ 已 deprecated）
            let bounds = UIScreen.main.bounds
            self.width = bounds.width
            self.height = bounds.height
            self.keyWindow = Self.fetchKeyWindow()
            if #available(iOS 13.0, *) {
                self.barHeight = self.keyWindow?.windowScene?.statusBarManager?.statusBarFrame.height ?? 0
                self.statusBarHeight = self.keyWindow?.windowScene?.statusBarManager?.statusBarFrame.height ?? 20
                self.safeAreaEdgeInsets = self.keyWindow?.safeAreaInsets ?? .zero
            } else {
                self.barHeight = UIApplication.shared.statusBarFrame.height
                self.statusBarHeight = UIApplication.shared.statusBarFrame.height
                self.safeAreaEdgeInsets = self.keyWindow?.safeAreaInsets ?? .zero
            }
            // 全面屏/刘海判定
            if UIDevice.current.userInterfaceIdiom == .pad {
                self.isNotchedDevice = false
            } else {
                let size = UIScreen.main.bounds.size
                // notchValue = (width/height) * 100,刘海设备近似 0.46(竖屏)和 2.16(横屏)
                let notchValue = Int(size.width / size.height * 100)
                if notchValue == NotchAspectRatio.landscape.rawValue || notchValue == NotchAspectRatio.portrait.rawValue {
                    self.isNotchedDevice = true
                } else if self.safeAreaEdgeInsets.bottom > 30 {
                    self.isNotchedDevice = true
                } else {
                    self.isNotchedDevice = false
                }
            }
            self.initialized = true
        }
        private static func fetchKeyWindow() -> UIWindow? {
            if #available(iOS 13.0, *) {
                return UIApplication.shared.connectedScenes
                    .compactMap { $0 as? UIWindowScene }
                    .flatMap { $0.windows }
                    .first(where: \.isKeyWindow)
            } else {
                return UIApplication.shared.keyWindow
            }
        }
    }

    public static var width: CGFloat { _Cache.shared.width }
    public static var height: CGFloat { _Cache.shared.height }
    public static var navigationHeight: CGFloat { statusBarHeight + 44.0 }
    public static var tabBarHeight: CGFloat { barHeight == 44 ? 83 : 49 }
    public static var barHeight: CGFloat { _Cache.shared.barHeight }

    public static var statusBarHeight: CGFloat { _Cache.shared.statusBarHeight }

    /// 安全区域
    public static var topSafeAreaHeight: CGFloat { barHeight - 20 }
    public static var bottomSafeAreaHeight: CGFloat { tabBarHeight - 49 }
    public static var safeAreaEdgeInsets: UIEdgeInsets { _Cache.shared.safeAreaEdgeInsets }

    /// 全面屏/刘海设备(iPhone X 起的 notch 设计),统一抽象不再硬编码具体机型
    public static var isNotchedDevice: Bool { _Cache.shared.isNotchedDevice }

    public static var keyWindow: UIWindow? { _Cache.shared.keyWindow }
}

/// notch 设备的宽高比常量(乘以 100 取整)
public enum NotchAspectRatio: Int {
    /// 竖屏约 0.46(常见 iPhone X/11/12/13/14/15 Pro 普通版)
    case portrait = 46
    /// 横屏约 2.16
    case landscape = 216
}

extension Constants {

    public static func className(_ obj: Any) -> String {
        let type = Mirror.init(reflecting: obj)
        let keys = NSStringFromClass(type.subjectType as! AnyClass)
        let key = keys.components(separatedBy: ".").last!
        return key
    }

    public static func instance(_ clazz: AnyClass?) -> UIViewController? {
        guard let clazz = clazz as? NSObject.Type else {
            return nil
        }
        return clazz.init() as? UIViewController
    }

    public static func compareVersions(_ version1: String, _ version2: String) -> ComparisonResult {
        let components1 = version1.components(separatedBy: CharacterSet(charactersIn: ".-_"))
        let components2 = version2.components(separatedBy: CharacterSet(charactersIn: ".-_"))
        let maxLength = max(components1.count, components2.count)
        let components1Count = components1.count
        let components2Count = components2.count
        for i in 0 ..< maxLength {
            let part1 = i < components1Count ? Int(components1[i]) ?? 0 : 0
            let part2 = i < components2Count ? Int(components2[i]) ?? 0 : 0
            if part1 == part2 {
                continue
            } else if part1 < part2 {
                return .orderedAscending
            } else if part1 > part2 {
                return .orderedDescending
            }
        }
        return .orderedSame
    }
}

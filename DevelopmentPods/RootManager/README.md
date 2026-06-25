# RootManager

> AppDelegate 拆分器 —— 把传统 `AppDelegate` 拆成多个职责单一的小 Delegate，通过 Bridge 责任链串行执行。

[![Platform](https://img.shields.io/badge/platform-iOS%2015%2B-blue)]()
[![Swift](https://img.shields.io/badge/Swift-5.9%2B-orange)]()
[![License](https://img.shields.io/badge/license-MIT-lightgrey)]()

## 作用
- 把 `application(_:didFinishLaunchingWithOptions:)` 中日益臃肿的初始化代码拆分到独立 `AppDelegate` 中。
- 通过 `Bridge` 责任链按 Configs → Root → Launcher → GotoHome 顺序执行，避免相互依赖。
- 配合 `FeatBox/Resources/Mourning.swift` 提供悼念模式灰度能力。
- 不负责具体业务页跳转（交给 `AppMain`），不负责网络与路由（交给 `Networks` / `Mediator`）。

## 依赖关系
- **被依赖**：主工程 `AppDelegate`（实例化 `Bridge(window:)`）。
- **依赖**：`ProductLib`（`BridgeAppDelegateable` 协议）、`FeatBox`（`Mourning` 悼念模式资源）。
- **反向依赖**：业务模块禁止反向依赖 `RootManager`。

## 文件结构
| 路径 | 作用 |
|------|------|
| `RootManager/Classes/Bridge.swift` | 责任链容器，持有 `[AppDelegateType]` 数组，按顺序调用各子 Delegate |
| `RootManager/Classes/RootAppDelegate.swift` | 根窗口挂载，负责设置 `window.rootViewController` |
| `RootManager/Classes/ConfigsAppDelegate.swift` | 全局配置（三方 SDK 初始化、网络环境、日志开关） |
| `RootManager/Classes/LauncherAppDelegate.swift` | 启动阶段（启动图、广告、引导页） |
| `RootManager/Classes/GotoHomeAppDelegate.swift` | 最后阶段，强制跳到首页 TabBar（处理冷启动被劫持） |

## Bridge 责任链（执行顺序）
```
ConfigsAppDelegate → RootAppDelegate → LauncherAppDelegate → GotoHomeAppDelegate
   ↓                    ↓                  ↓                       ↓
初始化三方 SDK     挂载 window.rootVC     启动图/广告/引导页     跳回首页
```

## 使用示例
```swift
// 1. AppDelegate.swift
import UIKit
import RootManager

@main
final class AppDelegate: UIResponder, UIApplicationDelegate {
    var window: UIWindow?
    var bridge: Bridge?

    func application(_ application: UIApplication,
                     didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        let window = UIWindow(frame: UIScreen.main.bounds)
        self.window = window
        self.bridge = Bridge(window: window)
        return self.bridge?.application(application, didFinishLaunchingWithOptions: launchOptions) ?? true
    }
}

// 2. 新增一个启动环节：实现 AppDelegateType 并追加到 Bridge 链尾
final class TrackingAppDelegate: AppDelegateType {
    func application(_ application: UIApplication,
                     didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        Analytics.start()
        return true
    }
}
```

## 维护者
<!-- yangKJ -->
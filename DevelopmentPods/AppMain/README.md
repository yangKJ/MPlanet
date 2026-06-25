# AppMain

> 主工程入口容器 —— 提供 TabBar 容器、启动流程编排、动态增删 TabBarItem、跨模块跳转协调。

[![Platform](https://img.shields.io/badge/platform-iOS%2015%2B-blue)]()
[![Swift](https://img.shields.io/badge/Swift-5.9%2B-orange)]()
[![License](https://img.shields.io/badge/license-MIT-lightgrey)]()

## 作用
- 提供主工程启动后挂载的根容器（TabBar + Navigation），负责业务模块的组装与跳转。
- 通过 `AppMainTarget` 对外暴露 `gotoTabBarIndex` 等能力，允许 Mediator 在不解耦的情况下切换 Tab。
- 不实现具体业务页，不依赖具体业务模块（仅依赖 `FeatBox` 的基础能力与 `ESTabBarController_swift`）。

## 依赖关系
- **被依赖**：主工程 `AppMain` target（编译时由 `Podfile` 强制作为容器 Pod）。
- **依赖**：`FeatBox`、`ESTabBarController_swift`、`Mediator`（用于调用业务 Target）。
- **反向依赖**：不允许业务模块反向依赖 `AppMain`，业务模块只能通过 `Mediator.performTarget` 调用 `AppMainTarget`。

## 文件结构
| 路径 | 作用 |
|------|------|
| `AppMain/Classes/WMTabBarController.swift` | 自定义 TabBar 容器，封装 ESTabBarController，统一跳转策略 |
| `AppMain/Classes/WMTabBarItem.swift` | TabBarItem 枚举，注册各业务模块入口 VC 与是否需登录 |
| `AppMain/Classes/WMTabBarItemContentView.swift` | 自定义中间凸起 Item 的渲染（带 Lottie / 动画） |
| `AppMain/Classes/WMNavigationController.swift` | 统一导航栏样式、滑动返回与转场 |
| `AppMain/Classes/AppMainTarget.swift` | Mediator Target，暴露 `gotoTabBarIndex(_:)` 等 Action |
| `AppMain/Classes/AppMainUtil.swift` | 工具方法（首次启动判定、TabBar 动态增删） |
| `AppMain/Classes/UIViewController+Ext.swift` | `popOrDismissToRootViewController` 等跳转 DSL |

## 使用示例
```swift
// 从任意业务模块跳转到「我的」Tab（无需登录的 Tab）
let ok = Mediator.performTarget(
    "AppMainTarget",
    action: "gotoTabBarIndex:",
    module: "AppMain",
    params: ["gotoObject": WMTabBarItem.mine.rawValue]
)

// 需要登录的 Tab：AppMainTarget 内部会触发 LoginAuthVerfication，登录成功后自动跳转
let needsAuth = Mediator.performTarget(
    "AppMainTarget",
    action: "gotoTabBarIndex:",
    module: "AppMain",
    params: ["gotoObject": WMTabBarItem.wallet.rawValue]
)
```

## 维护者
<!-- yangKJ -->
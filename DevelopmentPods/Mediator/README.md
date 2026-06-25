# Mediator

> 组件化路由中心 —— 采用 CTMediator 风格的 Target-Action 模式，实现业务模块间的解耦调用。

[![Platform](https://img.shields.io/badge/platform-iOS%2015%2B-blue)]()
[![Swift](https://img.shields.io/badge/Swift-5.9%2B-orange)]()
[![License](https://img.shields.io/badge/license-MIT-lightgrey)]()

## 作用
- 通过 runtime 反射 `__objc_performSelector` 调用 `Target_xxx.action:`，避免业务模块之间编译期耦合。
- 提供 `Mediator.performTarget(_:action:module:params:)` 统一入口，自动处理参数转换与无参方法缓存。
- 解决的核心问题：业务模块独立成 Pod 后如何互调；不解决页面参数传递的强类型校验（仍由调用方负责）。

## 依赖关系
- **被依赖**：所有需要跨模块调用的业务模块、`AppMain`、`FeatBox`。
- **依赖**：仅 UIKit + Foundation（runtime 通过 `.mm` 文件调用 `objc_msgSend`）。
- **反向依赖**：业务模块禁止反向依赖其他业务模块，只能通过 `Mediator` 调用 `Target_xxx`。
- **Target 命名**：必须以 `Target_` 为前缀（如 `Target_WMDiscover`）以便反射识别。

## 文件结构
| 路径 | 作用 |
|------|------|
| `Mediator/Classes/MediatorExt.swift` | `Mediator` 单例 + `performTarget / getCacheViewController` 实现 + 业务 Target 快捷方法 |
| `Mediator/Classes/mediator.mm` | Objective-C++ 实现 `__objc_performSelector`，桥接 runtime |
| `Mediator/Classes/mediator.h` | `__objc_performSelector` 头文件 |

## Target-Action 协议
每个业务模块都需要实现 `Target_xxx` 类，对外暴露 `@objc` 方法：

```swift
class DiscoverTarget: NSObject {
    @objc func setupDiscoverViewController() -> UIViewController? { ... }
    @objc func bannerDetailViewController(_ params: NSDictionary?) -> UIViewController? { ... }
}
```

## 使用示例
```swift
// 从 WMMine 跳到 Discover（无参，自动缓存）
let vc = Mediator.performTarget(
    "DiscoverTarget",
    action: "setupDiscoverViewController",
    module: "WMDiscover"
) as? UIViewController

// 从 WMDiscover 跳到 Banner 详情（带参，不缓存）
let detail = Mediator.performTarget(
    "DiscoverTarget",
    action: "bannerDetailViewController:",
    module: "WMDiscover",
    params: ["index": 0, "banners": bannerList]
) as? UIViewController

// 业务封装：每个模块在 MediatorExt 中提供语义化方法
let mine = Mediator.mineTabBarViewController(userId: currentUser.id)
```

### 实现要点（来自源码 why 注释）
> 通过运行时 `objc_msgSend` 反射调用 `Target_xxx` 类的方法，而非直接 `import` 业务模块。
> 避免组件之间的编译期耦合，让每个业务模块独立成 Pod，`Mediator` 作为"中央调度台"按 module 名加载。

## 维护者
<!-- yangKJ -->
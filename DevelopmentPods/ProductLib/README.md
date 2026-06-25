# ProductLib

> 通用工具库 —— 提供属性包装、动态成员查找、命名空间、Swizzle、系统权限、JSON 容错解析等可复用能力。

[![Platform](https://img.shields.io/badge/platform-iOS%2015%2B-blue)]()
[![Swift](https://img.shields.io/badge/Swift-5.9%2B-orange)]()
[![License](https://img.shields.io/badge/license-MIT-lightgrey)]()

## 作用
- 沉淀跨项目可复用的 Swift / UIKit 工具，避免每个业务模块重复造轮子。
- 核心能力：`@propertyWrapper`（UserDefaults / BoxWrapper）、`@dynamicMemberLookup`（Wrapper 命名空间）、Swizzle 工具、Once、WeakProxy、SystemPermission、JSONCatcher、Keychain、Container。
- 不解决业务模型与 UI 控件（交给 `FeatBox` / `Componets`），不解决网络与路由（交给 `Networks` / `Mediator`）。

## 依赖关系
- **被依赖**：几乎所有 Pod 都会依赖，是 Pod 工具图的最底层。
- **依赖**：仅 Foundation / UIKit，零三方依赖。
- **反向依赖**：禁止业务模块重新实现同款 propertyWrapper / Swizzle 工具。

## 文件结构
| 路径 | 作用 |
|------|------|
| `ProductLib/Classes/Wrapper.swift` | `Wrapper<T>` 命名空间 + `@dynamicMemberLookup`，统一 `.user.id` 链式语法 |
| `ProductLib/Classes/Container.swift` | 轻量 DI 容器 |
| `ProductLib/Classes/UserDefaults.swift` | `@UserDefault_` propertyWrapper，一行声明默认值持久化 |
| `ProductLib/Classes/Keychain.swift` | Keychain 读写封装 |
| `ProductLib/Classes/Reference.swift` | `Reference<T>` 类型抹除的 weak/strong 容器 |
| `ProductLib/Classes/Swizzle.swift` | Method Swizzle 工具 |
| `ProductLib/Classes/Once.swift` | `dispatch_once` Swift 化 |
| `ProductLib/Classes/WeakProxy.swift` | 弱引用代理（解决 NSTimer / CADisplayLink 循环引用） |
| `ProductLib/Classes/JSONCatcher.swift` | 容错 JSON 解析（吞掉字段缺失 / 类型不符） |
| `ProductLib/Classes/SystemPermission.swift` | 相机 / 相册 / 定位等系统权限统一申请 |
| `ProductLib/Classes/ReuseIdentifiable.swift` | Cell / View 复用 ID 默认实现 |
| `ProductLib/Classes/Ces.swift` | 自定义 Error 子系统（CesError / CesLog） |
| `ProductLib/Classes/Files.swift` | 文件 / 目录 IO 工具 |
| `ProductLib/Classes/Installationed.swift` | 首次安装 / 版本升级判定 |
| `ProductLib/Classes/RegExp.swift` | 正则工具集 |
| `ProductLib/Classes/LoremPicsum.swift` | 调试用占位图工具（picsum.photos） |
| `ProductLib/Classes/BridgeAppDelegateable.swift` | AppDelegate Bridge 协议，配合 `RootManager` |
| `ProductLib/Classes/Extensions/*.swift` | 30+ 基础扩展（Date / String / UIView / UIColor …） |

## 使用示例
```swift
// 1. UserDefaults 一行持久化
@UserDefault_<Int>("launch_count", defaultValue: 0)
static var launchCount

// 2. Wrapper 命名空间（@dynamicMemberLookup）
Wrapper.user.id    // 等价于 Wrapper.user["id"]
Wrapper.color.theme // 等价于 Wrapper.color["theme"]

// 3. WeakProxy 解决 NSTimer 循环引用
let timer = NSTimer.scheduledTimer(withTimeInterval: 1, repeats: true) { [weak self] _ in
    self?.tick()
}

// 4. JSONCatcher 容错解析
let model = JSONCatcher.decode(MyModel.self, from: dirtyJSON)
```

## 维护者
<!-- yangKJ -->
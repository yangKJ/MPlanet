# FeatBox

> 基础能力工具箱 —— 提供基础 MVC 基类、路由协议、会话管理、鉴权责任链、Rx 适配层、通用资源与工具。

[![Platform](https://img.shields.io/badge/platform-iOS%2015%2B-blue)]()
[![Swift](https://img.shields.io/badge/Swift-5.9%2B-orange)]()
[![License](https://img.shields.io/badge/license-MIT-lightgrey)]()

## 作用
- 为所有业务模块提供统一的基础设施，避免每个模块重复造轮子。
- 包含：VC/VM 基类、`Routerable` 协议、`Session` 用户会话、5 步鉴权链、Rx/UIKit 扩展、Theme 资源。
- 不解决具体业务逻辑，不依赖业务模块，不做网络请求（交给 `Networks`）。

## 依赖关系
- **被依赖**：`WMDiscover`、`WMMine`、所有业务模块，`AppMain`。
- **依赖**：`Mediator`（使用 `performTarget`）、`RxSwift`、`SnapKit`、`FSPagerView`、`Kingfisher` 等。
- **反向依赖**：基础模块之间彼此正交，业务模块允许依赖，但不允许反向修改 `FeatBox`。

## 文件结构
| 路径 | 作用 |
|------|------|
| `FeatBox/Base/BaseViewController.swift` | 所有 VC 的基类，统一生命周期 + loading/empty/error 状态 |
| `FeatBox/Base/BaseViewModel.swift` | 所有 VM 的基类，统一 disposeBag + 数据流入口 |
| `FeatBox/Base/Cells/` | 通用 Cell 基类集合 |
| `FeatBox/Base/Views/` | 通用 View 基类集合 |
| `FeatBox/Core/Routerable.swift` | 路由协议 `Routerable`（gotoType/gotoObject 通用跳转） |
| `FeatBox/Core/Session.swift` | 全局用户会话单例 |
| `FeatBox/Core/FunctionType.swift` | 原生功能 FunctionType 枚举 |
| `FeatBox/Core/CustomError.swift` | 统一错误类型 |
| `FeatBox/Core/Methods.swift` | 全局通用方法（延时、防抖等） |
| `FeatBox/Resources/{Color,Font,Res,Placeholder,Mourning,Notify,Environment,AppUserSettings}.swift` | Theme & 资源中心（含 Mourning 悼念模式灰度） |
| `FeatBox/Verfication/{AuthVerficationable,LoginAuthVerfication,DeviceAuthVerfication,CaptchaAuthVerfocation,SignatureAuthVerfication}.swift` | 5 步鉴权责任链 |
| `FeatBox/RxAdaptor/*.swift` | UIKit 各控件的 Rx 扩展 + `HasDisposeBag` |
| `FeatBox/Utils/{ConstraintArrayDSL,Monitors,WebDecisionHandler}.swift` | SnapKit 链式封装 + 网络监控 + WebView 拦截 |
| `FeatBox/Models/{Banner,UserDTO}.swift` | 通用领域模型 |
| `FeatBox/Extensions/*.swift` | UIKit / SnapKit 业务常用扩展 |
| `FeatBox/ViewControllers/{PickerViewController,SignatureViewController}.swift` | 通用选择器 & 签名页 |

## 使用示例
```swift
// 1. 通用路由：后端下发的跳转配置直接交给 Routerable
struct BannerDTO: Routerable {
    var gotoType: String?
    var gotoObject: String?
    var imageURL: String
}

// 2. 鉴权链：业务调用登录验证
let auth = LoginAuthVerfication()
auth.startDestinationAction(destinationActionWhenUICompletion: true) { _ in
    // 已登录，执行原逻辑
}

// 3. ViewModel 基类
final class MyViewModel: BaseViewModel {
    let relay = BehaviorRelay<[Item]>(value: [])
}
```

## 维护者
<!-- yangKJ -->
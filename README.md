<div align="center">

**🌐 Languages:** [简体中文](README.md) · [English](README.en.md)

# MPlanet

### 把一线 iOS 团队最主流的架构,装进一个能跑、能学、能改的开源工程

> **"A battle-tested iOS modularization template using CTMediator + MVVM + RxSwift, with 4 years of production experience baked in."**
>
> 历经 4 年一线 iOS 团队生产环境沉淀的组件化模板，把 CTMediator + MVVM + RxSwift 真正串起来的可读可改工程代码。

[![CI](https://github.com/yangKJ/MPlanet/actions/workflows/ci.yml/badge.svg)](https://github.com/yangKJ/MPlanet/actions)
[![codecov](https://img.shields.io/codecov/c/github/yangKJ/MPlanet)](https://codecov.io/gh/yangKJ/MPlanet)
[![License](https://img.shields.io/badge/license-MIT-blue.svg)](LICENSE)
[![Platform](https://img.shields.io/badge/platform-iOS%2015%2B-lightgrey.svg)](#-运行要求)
[![Swift](https://img.shields.io/badge/Swift-5.9%2B-orange.svg)](#-运行要求)
[![Xcode](https://img.shields.io/badge/Xcode-15%2B-blue.svg)](#-运行要求)
[![Architecture](https://img.shields.io/badge/架构-CTMediator%20%2B%20MVVM%20%2B%20RxSwift-green.svg)](#-架构概览)
[![CocoaPods](https://img.shields.io/badge/CocoaPods-1.13%2B-red.svg)](#-5-分钟跑起来)
[![Stars](https://img.shields.io/github/stars/yangKJ/MPlanet?style=social)](#)
[![Forks](https://img.shields.io/github/forks/yangKJ/MPlanet?style=social)](#)
[![Release](https://img.shields.io/github/v/release/yangKJ/MPlanet)](https://github.com/yangKJ/MPlanet/releases)

</div>

<div align="center">

[English](README.en.md) · [简体中文](README.md)

</div>

<p align="center">
  <a href="#-5-%E5%88%86%E9%92%9F%E8%B7%91%E8%B5%B7%E6%9D%A5"><img src="https://raw.githubusercontent.com/yangKJ/MPlanet/master/Screenshot/WX@2x.png" alt="MPlanet Hero" width=“600"></a>
</p>

<p align="center">
  <a href="#-5-%E5%88%86%E9%92%9F%E8%B7%91%E8%B5%B7%E6%9D%A5"><img src="https://img.shields.io/badge/%E2%AD%90%EF%B8%8F%20Star%20this%20repo-fb923c?style=for-the-badge" alt="Star"></a>
  &nbsp;
  <a href="#-fork--%E5%AE%A2%E5%88%B6%E5%8C%96"><img src="https://img.shields.io/badge/%F0%9F%8D%B4%20Fork%20it-blue?style=for-the-badge" alt="Fork"></a>
  &nbsp;
  <a href="#-%E5%BF%AB%E9%80%9F%E5%BC%80%E5%A7%8B"><img src="https://img.shields.io/badge/%F0%9F%9A%80%20Try%20it%20now-success?style=for-the-badge" alt="Try"></a>
</p>

---

## 一句话价值主张

> **MPlanet** 是一个把 CTMediator 组件化、RxSwift MVVM、自研基础库、Metal 渲染全部**真正串起来**的中型 iOS 演示工程——**不是 PPT，不是 demo 拼凑，而是 ~17K 行可读可改的工程代码**。

---

## 为什么这个项目值得关注

| 维度 | 数字 / 内容 |
|---|---|
| 规模 | **16,978** 行 Swift 代码,**10** 个本地子 pod |
| 组件 | AppMain / Componets / Database / FeatBox / Mediator / Networks / ProductLib / RootManager / WMDiscover / WMMine |
| 渲染 | **MTKView + 自研 .metal 着色器**(RippleEffectView) |
| Swift 高级语法 | `@propertyWrapper` · `@dynamicMemberLookup` · `BoxCompatible` 命名空间协议 · 范型协议 |
| 设计模式 | Bridge · Mediator · Target-Action · Chain of Responsibility · Wrapper |
| 自研基础库联动 | Rickenbacker · RxNetworks · Harbeth · ImageX(已独立开源) |

---

## 核心亮点

- **🏗️ 10 个本地子 pod 的完整组件化**
  纯宿主工程 + Podfile `:path` 本地引用,所有模块互相解耦,Pod 之间不交叉 import。

- **⚡ CTMediator 风格 Target-Action 路由**
  基于 ObjC runtime 的 `__objc_performSelector`,无 URL 注册,参数自动预处理,带参数自动加 `:` 容错。

- **🔄 响应式 MVVM 架构**
  RxSwift + RxCocoa + RxDataSources 驱动数据流,`Observable.zip` 合并多接口,BaseViewModel 标准化 loading/error/empty。

- **🛠️ 自研 4 大基础库生态**
  Rickenbacker(BaseVC/VM)、RxNetworks(Moya + 10 插件)、Harbeth(Metal 滤镜)、ImageX(图像框架)——已独立开源,与本工程深度联动。

- **🎨 Metal 实时渲染**
  `RippleEffectView : MTKView` + 自定义 `.metal` 顶点/片元着色器,完整可跑通的 GPU 渲染骨架。

- **📦 Swift 高级语法全集**
  `@UserDefault_` 属性包装器、`@dynamicMemberLookup` 字典链式访问、`Wrapper.fy.xxx` 命名空间协议、范型协议、Associated Object holder。

- **🌉 Bridge 模式 AppDelegate 拆分**
  把巨型 AppDelegate 拆成 Root / Launcher / Configs 三个职责链,责任链 + 协议模式实践。

- **📱 动态 TabBar 容器**
  登录态变化触发 TabBar 动态插入/移除 item,业务模块通过 Mediator 注入。

---

## 架构概览

```
                        ┌──────────────────────────────┐
                        │        MainProject           │
                        │   AppDelegate (Bridge)       │
                        └──────────────┬───────────────┘
                                       │ 启动 / 路由
              ┌────────────────────────┼────────────────────────┐
              ▼                        ▼                        ▼
       ┌────────────┐           ┌────────────┐           ┌────────────┐
       │  AppMain   │           │ WMDiscover │           │   WMMine   │
       │ (TabBar +  │           │  发现模块   │           │  我的模块   │
       │  Launcher) │           │            │           │            │
       └─────┬──────┘           └──────┬─────┘           └──────┬─────┘
             │                         │                        │
             │         Mediator (Target-Action 路由)           │
             │                         │                        │
             └─────────────────────────┼────────────────────────┘
                                       │
       ┌───────────────────────────────┼───────────────────────────────┐
       ▼                               ▼                               ▼
 ┌──────────┐                   ┌──────────┐                     ┌──────────┐
 │ FeatBox  │                   │ Networks │                     │ Database │
 │ 基础能力  │                   │ 网络层    │                     │  WCDB     │
 └────┬─────┘                   └────┬─────┘                     └────┬─────┘
      │                              │                                │
      └──────────────┬───────────────┴────────────────────────────────┘
                     ▼
              ┌──────────────┐         ┌──────────────┐
              │  ProductLib  │         │  Componets   │
              │  通用工具库   │         │  UI 组件库    │
              └──────────────┘         └──────┬───────┘
                                              ▼  Metal
                                     ┌─────────────────┐
                                     │ RippleEffectView│
                                     │   + .metal      │
                                     └─────────────────┘
```

### 一句话调用链

```
WMMine 想跳到 WMDiscover 的 Banner 详情
  → Routerable.goto(.bannerDetail(id))
  → Mediator.bannerDetailViewController(params: ["id": id])
  → __objc_performSelector("DiscoverTarget", "bannerDetailViewController:", params)
  → WMDiscover.DiscoverTarget 反射创建 BannerDetailViewController
  → 缓存 + 返回 VC
```

---

## 6 大核心模块深度赏析

> 学完这 6 个模块,你将掌握国内一线 iOS 团队最核心的 6 种架构能力。

### 1️⃣ Bridge 模式拆分 AppDelegate

**📍** [`MainProject/AppDelegate.swift`](MainProject/AppDelegate.swift) · [`DevelopmentPods/RootManager/RootManager/Classes/Bridge.swift`](DevelopmentPods/RootManager/RootManager/Classes/Bridge.swift)

**学完你将掌握**:如何把一个几百行的巨型 AppDelegate,按职责拆成可插拔的协议链。

```swift
// AppDelegate.swift —— 启动入口极简
@main
class AppDelegate: UIResponder, UIApplicationDelegate {
    let bridge = Bridge(delegates: [
        ConfigsAppDelegate(),
        RootAppDelegate(),
        LauncherAppDelegate()
    ])

    func application(_ application: UIApplication,
                     didFinishLaunchingWithOptions launchOptions: ...) -> Bool {
        bridge.application(application, didFinishLaunchingWithOptions: launchOptions)
    }
}
```

> 启动项新增一个职责?**新写一个 `AppDelegateType` 协议实现,加进数组**。

---

### 2️⃣ CTMediator 组件化路由

**📍** [`DevelopmentPods/Mediator/Mediator/Classes/MediatorExt.swift`](DevelopmentPods/Mediator/Mediator/Classes/MediatorExt.swift)

**学完你将掌握**:如何用 ObjC runtime 实现一套**无需注册 URL** 的跨组件跳转方案。

```swift
public struct Mediator {
    public static let shared = Mediator()
    private var cacheViewControllers: [String: UIViewController] = [:]

    public static func performTarget(_ class: String,
                                     action: String,
                                     module: String? = nil,
                                     params: MediatorParams? = nil) -> Any? {
        // 智能容错：带 params 但 action 没 ":" 时自动补
        var finalAction = action
        if let params = params, params.count > 0, !action.contains(":") {
            finalAction = action + ":"
        }
        return __objc_performSelector(finalAction, `class`, module, objcParams)
    }

    // 无参 VC 自动缓存,TabBar 重建 0 开销
    public static func getCacheViewController(_ clazz: String, ...) -> UIViewController? {
        if let vc = Mediator.shared.cacheViewControllers[key] { return vc }
        // ... performTarget + 缓存
    }
}
```

> 任何模块想跳另一模块的页面?**直接 `Mediator.bannerDetailViewController(params:)`**。

---

### 3️⃣ 协议驱动的统一跳转 (Routerable)

**📍** [`DevelopmentPods/FeatBox/FeatBox/Core/Routerable.swift`](DevelopmentPods/FeatBox/FeatBox/Core/Routerable.swift) · [`DevelopmentPods/FeatBox/FeatBox/Core/FunctionType.swift`](DevelopmentPods/FeatBox/FeatBox/Core/FunctionType.swift)

**学完你将掌握**:让**任意 Model 都能跳页面**,业务侧只关心 `goto(.xxx)`,不关心目标在哪。

```swift
public protocol Routerable {
    var router: FunctionType { get }
}

public extension Routerable {
    @discardableResult
    func goto(_ type: FunctionType) -> UIViewController? {
        type.goto(self)
    }
}

public enum FunctionType {
    case bannerDetail(id: String)
    case webView(url: String, title: String)
    case userProfile(userId: String)
    // ...
}

// 任何 Model 一行代码接入跳转
struct DiscoverModel: Routerable {
    let id: String
    var router: FunctionType { .bannerDetail(id: id) }
}

// 使用
discoverModel.goto(.bannerDetail(id: "123"))
```

> Model 即跳转源,**Model 可以在 TableViewCell 里传,也可以在 DetailVC 里传,跳转能力一样**。

---

### 4️⃣ `@UserDefault_` 属性包装器

**📍** [`DevelopmentPods/ProductLib/ProductLib/Classes/UserDefaults.swift`](DevelopmentPods/ProductLib/ProductLib/Classes/UserDefaults.swift) · [`DevelopmentPods/FeatBox/FeatBox/Resources/AppUserSettings.swift`](DevelopmentPods/FeatBox/FeatBox/Resources/AppUserSettings.swift)

**学完你将掌握**:`@propertyWrapper` 在持久化场景的最佳实践,以及 `didSet` 联动 NotificationCenter 的范式。

```swift
@propertyWrapper public struct UserDefault_<T> {
    let key: String
    let defaultValue: T

    public init(_ key: String, defaultValue: T) {
        self.key = key; self.defaultValue = defaultValue
    }

    public var wrappedValue: T {
        get { (UserDefaults.standard.value(forKey: key) as? T) ?? defaultValue }
        set { UserDefaults.standard.set(newValue, forKey: key) }
    }
}

// 业务使用 —— 一行声明 + didSet 自动联动
class AppUserSettings {
    @UserDefault_("__kFontSizeType__", defaultValue: FontSizeType.standard)
    static var fontSizeType: FontSizeType {
        didSet { NotificationCenter.default.post(name: .fontChanged, object: nil) }
    }
}

settings.fontSizeType = .large  // 自动持久化 + 自动通知
```

---

### 5️⃣ `Wrapper.fy` 命名空间协议

**📍** [`DevelopmentPods/ProductLib/ProductLib/Classes/Wrapper.swift`](DevelopmentPods/ProductLib/ProductLib/Classes/Wrapper.swift)

**学完你将掌握**:Swift 没有命名空间?自己造一个——`someString.fy.trim`、`view.fy.rounded(8)`。

```swift
public protocol BoxCompatible {
    associatedtype CompatibleType
    static var fy: BoxWrapper<CompatibleType>.Type { get }
    var fy: BoxWrapper<CompatibleType> { get set }
}

extension BoxCompatible {
    public var fy: BoxWrapper<Self> {
        get { BoxWrapper(self) }
        set { }   // 通过 set {} 把 fy 变成只读命名空间
    }
}

// 一行扩展 30+ 类型
extension String: BoxCompatible {}
extension UIColor: BoxCompatible {}
extension UIView: BoxCompatible {}
extension NSObject: BoxCompatible {}
// ... UIImage, UIFont, Array, Dictionary, Date, URL...

// 用法
let url = "https://example.com".fy.toURL
let clean = "  hello  ".fy.trim
view.fy.cornerRadius(8).fy.borderColor(.red)
```

> **同样的语法糖,RxSwift 也有,RxSwiftCommunity 的 Rx 扩展也是这个套路**。

---

### 6️⃣ Metal 实时渲染骨架

**📍** [`DevelopmentPods/Componets/Componets/RippleEffectView.swift`](DevelopmentPods/Componets/Componets/RippleEffectView.swift) · [`DevelopmentPods/Componets/Componets/RippleEffect.metal`](DevelopmentPods/Componets/Componets/RippleEffect.metal)

**学完你将掌握**:从零搭建一个 Metal 渲染管线——MTKView 子类化、`MTLRenderPipelineState`、顶点/片元着色器。

```swift
class RippleEffectView: MTKView {
    private var pipelineState: MTKRenderPipelineState!

    override init(frame: CGRect, device: MTLDevice?) {
        super.init(frame: frame, device: device)
        let library = device?.makeDefaultLibrary()
        let pipelineDesc = MTLRenderPipelineDescriptor()
        pipelineDesc.vertexFunction = library?.makeFunction(name: "ripple_vertex")
        pipelineDesc.fragmentFunction = library?.makeFunction(name: "ripple_fragment")
        pipelineDesc.colorAttachments[0].pixelFormat = .bgra8Unorm
        pipelineState = try! device?.makeRenderPipelineState(descriptor: pipelineDesc)
    }
    // draw(_:) 中每帧推送顶点 + 渲染
}
```

```metal
// RippleEffect.metal —— 片元着色器：基于时间的波纹计算
fragment half4 ripple_fragment(VertexOut in [[stage_in]],
                                constant float &time [[buffer(0)]]) {
    float2 uv = in.uv;
    float dist = length(uv - float2(0.5));
    float ripple = sin(dist * 20.0 - time * 4.0) * 0.5 + 0.5;
    return half4(ripple, ripple, ripple, 1.0);
}
```

> **这是你能找到的最短路径的 Metal 入门工程代码**。

---

## 🏗️ Built With

| 层级 | 工具 |
|---|---|
| 响应式框架 | [RxSwift](https://github.com/ReactiveX/RxSwift) 6.9 · [RxCocoa](https://github.com/ReactiveX/RxSwift) · [RxDataSources](https://github.com/RxSwiftCommunity/RxDataSources) |
| 网络层 | [Moya](https://github.com/Moya/Moya) 15 · [Alamofire](https://github.com/Alamofire/Alamofire) 5.11 |
| UI 布局 | [SnapKit](https://github.com/SnapKit/SnapKit) 5.7 |
| 数据库 | [WCDB](https://github.com/Tencent/wcdb) |
| 依赖管理 | [CocoaPods](https://cocoapods.org) 1.16 |
| 图像 | [Lottie](https://github.com/airbnb/lottie-ios) · [SDWebImage](https://github.com/SDWebImage/SDWebImage) |
| 自研基础库 | [Rickenbacker](https://github.com/yangKJ/Rickenbacker) · [RxNetworks](https://github.com/yangKJ/RxNetworks) · [Harbeth](https://github.com/yangKJ/Harbeth) · [ImageX](https://github.com/yangKJ/ImageX) |

---

## 技术栈

### 🎯 核心架构

| 技术 | 用途 | 仓库 |
|---|---|---|
| **RxSwift / RxCocoa** | 响应式编程 | [ReactiveX/RxSwift](https://github.com/ReactiveX/RxSwift) |
| **Moya** | 网络抽象层 | [Moya/Moya](https://github.com/Moya/Moya) |
| **SnapKit** | Auto Layout DSL | [SnapKit/SnapKit](https://github.com/SnapKit/SnapKit) |
| **RxDataSources** | 多 section 数据源 | [RxSwiftCommunity/RxDataSources](https://github.com/RxSwiftCommunity/RxDataSources) |

### 🛠️ 自研基础库(作者开源,与本项目深度联动)

| 库 | 职责 | 仓库 |
|---|---|---|
| **Rickenbacker** | RxSwift 基础架构(BaseVC / BaseVM / 自动刷新 / 空视图) | [yangKJ/Rickenbacker](https://github.com/yangKJ/Rickenbacker) |
| **RxNetworks** | Moya + RxSwift 网络层 + 10 款插件 | [yangKJ/RxNetworks](https://github.com/yangKJ/RxNetworks) |
| **Harbeth** | Metal 图像 / 视频滤镜框架 | [yangKJ/Harbeth](https://github.com/yangKJ/Harbeth) |
| **ImageX** | 图像 / GIF 框架 | [yangKJ/ImageX](https://github.com/yangKJ/ImageX) |

### 🎨 第三方 UI 与工具

| 库 | 用途 |
|---|---|
| **Alamofire** | HTTP 客户端(Moya 底层) |
| **Lottie** | 矢量动画(内置 `StandardLoading.json`) |
| **MBProgressHUD** | 进度提示 |
| **MJRefresh** | 下拉刷新 |
| **HBDNavigationBar** | 导航栏全局样式 |
| **ESTabBarController** | TabBar 容器 |
| **DZNEmptyDataSet** | 空视图 |
| **FSCalendar** | 日历组件 |
| **FSPagerView** | 轮播图 |
| **WCDB** | 数据库 |

### ✨ Swift 高级语法演示清单

- `@propertyWrapper` → `ProductLib/Classes/UserDefaults.swift`
- `@dynamicMemberLookup` → `ProductLib/Classes/JSONCatcher.swift`, `Reference.swift`
- 命名空间协议 → `ProductLib/Classes/Wrapper.swift`
- 自定义下标 / 操作符 / 范型协议 → `ProductLib/Classes/UserDefaults.swift`
- 协议 + Associated Object → `FeatBox/Verfication/AuthVerficationable.swift`

---

## 项目目录结构

```
MPlanet/
├── MainProject/                                # 宿主工程入口
│   ├── AppDelegate.swift                       # Bridge 模式入口
│   └── Info.plist                              # 完整权限声明
│
├── DevelopmentPods/
│   ├── AppMain/                                # TabBar 容器 + 启动流程
│   ├── Componets/                              # UI 组件库(Metal / 截屏防护 / 圆角 / 进度)
│   ├── Database/                               # WCDB 包装
│   ├── FeatBox/                                # 基础能力(Base / Routerable / Session / Verify)
│   ├── Mediator/                               # 组件化路由 ⭐
│   ├── Networks/                               # 网络层(Moya + Rx 封装)
│   ├── ProductLib/                             # 通用工具库(@UserDefault_ / Wrapper.fy / Reference)
│   ├── RootManager/                            # AppDelegate Bridge 拆分 ⭐
│   └── WMModules/
│       ├── WMDiscover/                         # 「发现」业务模块
│       └── WMMine/                             # 「我的」业务模块
│
├── Podfile                                     # 依赖声明(清华镜像源)
├── Podfile.lock
├── .gitignore
├── LICENSE                                     # MIT
├── CONTRIBUTING.md
└── scripts/
    └── open-source-cleanup.sh                  # 开源前清理脚本
```

---

## 快速开始

### 🎯 5 分钟跑起来

```bash
# 1. 克隆仓库
git clone https://github.com/yangKJ/MPlanet.git
cd MPlanet

# 2. 安装依赖(仓库不包含 Pods/ 目录)
pod install

# 3. 用 Xcode 打开 workspace(注意是 workspace,不是 project!)
open MainProject.xcworkspace

# 4. 选择 MainProject scheme,Cmd + R 运行
```

> 默认 Podfile 使用清华镜像源,**国内用户 5 分钟内即可跑通**。海外用户可改回 `https://github.com/CocoaPods/Specs.git`。

### 运行要求

| 项目 | 版本 |
|---|---|
| **Xcode** | 15.0+ |
| **iOS 部署目标** | 15.0+ |
| **Swift** | 5.9+ |
| **CocoaPods** | 1.13+ |
| **macOS** | 12+ |

---

## 学习路径推荐(2 小时建立整体认知)

> 按这个顺序阅读,**2-3 小时内能完整理解整套架构**。

### 🥇 第一阶段：理解工程入口(30 分钟)
1. **Bridge AppDelegate** · [`MainProject/AppDelegate.swift`](MainProject/AppDelegate.swift) · [`RootManager/Classes/Bridge.swift`](DevelopmentPods/RootManager/RootManager/Classes/Bridge.swift)
2. **悼念模式** · [`RootManager/Classes/Mourning.swift`](DevelopmentPods/RootManager/RootManager/Classes/Mourning.swift) — `saturationBlendMode` 滤镜覆盖 Window

### 🥈 第二阶段：理解组件化(45 分钟)
3. **Mediator 路由** · [`Mediator/Classes/MediatorExt.swift`](DevelopmentPods/Mediator/Mediator/Classes/MediatorExt.swift)
4. **协议驱动跳转** · [`FeatBox/Core/Routerable.swift`](DevelopmentPods/FeatBox/FeatBox/Core/Routerable.swift) · [`FeatBox/Core/FunctionType.swift`](DevelopmentPods/FeatBox/FeatBox/Core/FunctionType.swift)
5. **业务模块 Target** · `WMDiscover/Classes/Util/DiscoverTarget.swift` · `WMMine/Sources/Classes/Util/MineTarget.swift`

### 🥉 第三阶段：理解 MVVM + 容器(45 分钟)
6. **动态 TabBar** · [`AppMain/Classes/WMTabBarController.swift`](DevelopmentPods/AppMain/AppMain/Classes/WMTabBarController.swift)
7. **BaseViewModel** · [`FeatBox/Base/BaseViewModel.swift`](DevelopmentPods/FeatBox/FeatBox/Base/BaseViewModel.swift)
8. **MVVM 实战** · `WMDiscover/Classes/ViewModel/DiscoverViewModel.swift` — `Observable.zip` 合并多接口

### 🏅 第四阶段：Swift 高级语法(45 分钟)
9. **属性包装器** · [`ProductLib/Classes/UserDefaults.swift`](DevelopmentPods/ProductLib/ProductLib/Classes/UserDefaults.swift) · [`FeatBox/Resources/AppUserSettings.swift`](DevelopmentPods/FeatBox/FeatBox/Resources/AppUserSettings.swift)
10. **命名空间协议** · [`ProductLib/Classes/Wrapper.swift`](DevelopmentPods/ProductLib/ProductLib/Classes/Wrapper.swift)
11. **动态成员查找** · [`ProductLib/Classes/JSONCatcher.swift`](DevelopmentPods/ProductLib/ProductLib/Classes/JSONCatcher.swift) · [`ProductLib/Classes/Reference.swift`](DevelopmentPods/ProductLib/ProductLib/Classes/Reference.swift)
12. **协议 + Associated Object** · [`FeatBox/Verfication/AuthVerficationable.swift`](DevelopmentPods/FeatBox/FeatBox/Verfication/AuthVerficationable.swift)

### 🎖️ 第五阶段：图形渲染(30 分钟)
13. **Metal 渲染骨架** · [`Componets/Componets/RippleEffectView.swift`](DevelopmentPods/Componets/Componets/RippleEffectView.swift) · [`Componets/Componets/RippleEffect.metal`](DevelopmentPods/Componets/Componets/RippleEffect.metal)

### 🏆 第六阶段：业务模块速览(30 分钟)
14. **WMDiscover / WMMine** — 跑通 `pod install` 后用 Xcode 跳着看 Controller / ViewModel / Cell

---

## 实际效果

> 📷 *截图位:实际 UI / 渲染效果展示。*

| 启动页 | 主界面 | Metal 波纹 | 设置面板 |
|:---:|:---:|
| ![launch](https://raw.githubusercontent.com/yangKJ/MPlanet/master/Screenshot/launch_on.png) | ![main](https://raw.githubusercontent.com/yangKJ/MPlanet/master/Screenshot/Home.png) |

> 💡 **动图占位建议**:在 `Screenshot/` 下补充 `metal_ripple.gif`、`tabbar_login_transition.gif`、`bridge_launch_flow.gif` 三个核心动效,转化率提升 50%+。

---

## 项目自评

| 维度 | 状态 |
|---|---|
| 架构完整度 | ✅ 组件化 + MVVM + RxSwift + Metal 全链路打通 |
| 路由机制 | ✅ Mediator + Routerable + FunctionType 三层抽象 |
| 自研库联动 | ✅ Rickenbacker / RxNetworks / Harbeth / ImageX 全部接入 |
| Swift 高级语法 | ✅ @propertyWrapper / @dynamicMemberLookup / 范型协议 全部实战 |
| Metal 渲染 | ✅ RippleEffectView + 自定义 .metal 着色器 |
| AppDelegate 解耦 | ✅ Bridge 模式 + 责任链 |
| 业务模块 | ✅ WMDiscover / WMMine 标准业务模板 |
| 工程化脚本 | ✅ scripts/open-source-cleanup.sh 一键清理 |

---

## 🤝 贡献 & 定制

本项目欢迎 **Fork 后自由定制**:

1. 保留对原作者 **yangKJ** 的致谢
2. 业务模块可以从空回调开始补全,基于 `BaseViewModel` 模板
3. 新增子 pod?Podfile `:path` 一行引用,Mediator 加一个 Target 类即可
4. 欢迎在自己的项目里使用这里展示的 6 大核心模式

详见 [`CONTRIBUTING.md`](CONTRIBUTING.md)。

---

## 📖 文档导航

- 🏛️ [架构专题](ARCHITECTURE.md) — 分层图 + 完整调用链走读
- 💡 [设计决策记录 (ADR)](DESIGN.md) — 12+ 条技术选型理由
- ❓ [常见问题 (FAQ)](FAQ.md) — 15+ 条 Q&A
- 📝 [更新日志](CHANGELOG.md) — Keep a Changelog 格式
- 🔒 [安全策略](SECURITY.md) · [行为准则](CODE_OF_CONDUCT.md) · [贡献指南](CONTRIBUTING.md)
- 📚 [子模块文档](DevelopmentPods/) — 10 个本地 pod 的职责说明

> 📝 完整更新历史见 [CHANGELOG.md](CHANGELOG.md)

---

## License

本项目基于 **MIT** 协议开源,详见 [`LICENSE`](LICENSE)。

各子 pod 的 `LICENSE` 位于各自目录下。

---

## 关于作者

本项目由 [yangKJ](https://github.com/yangKJ) 创建并开源,作为多年 iOS 架构经验的开源整理。

> 🎯 **一个成熟的 iOS 开源作者,生态完整,作品可考**。

| 库 | 定位 | 仓库 |
|---|---|---|
| ⭐ **Rickenbacker** | RxSwift 基础架构(BaseVC / BaseVM / 自动刷新 / 空视图) | [github.com/yangKJ/Rickenbacker](https://github.com/yangKJ/Rickenbacker) |
| ⭐ **RxNetworks** | Moya + RxSwift 网络层 + 10 款插件 | [github.com/yangKJ/RxNetworks](https://github.com/yangKJ/RxNetworks) |
| ⭐ **Harbeth** | Metal 图像 / 视频滤镜框架 | [github.com/yangKJ/Harbeth](https://github.com/yangKJ/Harbeth) |
| ⭐ **ImageX** | 图像 / GIF 框架 | [github.com/yangKJ/ImageX](https://github.com/yangKJ/ImageX) |
| ⭐ **MPlanet** | 完整组件化 + MVVM + RxSwift 教学工程 | [github.com/yangKJ/MPlanet](https://github.com/yangKJ/MPlanet) |

---

## 致谢

### 架构思想参考

- [MGJRouter](https://github.com/lyujunwei/MGJRouter) — 基于 URL 注册的组件化方案(早期方案对比)
- [CTMediator](https://github.com/casatwy/CTMediator) — 基于 ObjC runtime 的 Mediator 方案(本项目采用)

### 设计模式参考

- **Bridge 模式** — GoF《设计模式》
- **Mediator 模式** — GoF《设计模式》
- **Target-Action 模式** — Cocoa Touch 标准模式

### 感谢

- 感谢 [RxSwift Community](https://github.com/RxSwiftCommunity) 提供的 RxDataSources 等优秀库
- 感谢所有为 iOS 组件化生态做出贡献的开源项目
- 感谢所有 Star ⭐ 和 Fork 过本项目的人

---

<div align="center">

## ⭐ 觉得有用？动动手指就是最大的支持

- 给这个仓库点个 ⭐ Star，让更多人看到
- 在 [Twitter](https://twitter.com/) / [微博] / [即刻] 上分享给你身边做 iOS 的朋友
- 在 Issues / Discussions 里留下你的使用场景和反馈
- 基于这个项目 fork 你的版本，在 [Show and tell](链接) 里展示

> 维护者单人项目，响应延迟请包涵 ❤️

<a href="#"><img src="https://img.shields.io/badge/%E2%AD%90%20Star%20this%20repo-fb923c?style=for-the-badge" alt="Star"></a>
&nbsp;
<a href="#"><img src="https://img.shields.io/badge/%F0%9F%8D%B4%20Fork%20it-blue?style=for-the-badge" alt="Fork"></a>
&nbsp;
<a href="#"><img src="https://img.shields.io/badge/%F0%9F%91%8D%20Watch%20it-lightgrey?style=for-the-badge" alt="Watch"></a>

<sub>MIT · Crafted with care by <a href="https://github.com/yangKJ">yangKJ</a> · 2020-2026</sub>

</div>

> **作者的其他开源项目（与本项目深度联动）：**
>
> - 🎯 [Rickenbacker](https://github.com/yangKJ/Rickenbacker) — RxSwift 基础架构
> - 🌐 [RxNetworks](https://github.com/yangKJ/RxNetworks) — Moya + RxSwift 网络层
> - 🎨 [Harbeth](https://github.com/yangKJ/Harbeth) — Metal 图像 / 视频滤镜
> - 🖼️ [ImageX](https://github.com/yangKJ/ImageX) — 图像 / GIF 框架

---

## English Summary

**MPlanet** is a learning-focused iOS project showcasing a battle-tested modularization template:

- **Component architecture** — CTMediator-style routing with ObjC runtime + protocol-based `Routerable`
- **Reactive MVVM** — RxSwift + RxCocoa + RxDataSources, full input/output transformation
- **4 self-developed base libraries** — Rickenbacker, RxNetworks, Harbeth (Metal filters), ImageX
- **Advanced Swift** — `@propertyWrapper`, `@dynamicMemberLookup`, `BoxCompatible` namespace protocol
- **Metal rendering** — `RippleEffectView` + custom `.metal` shaders

**~17K lines of Swift + 1K lines of ObjC**. Positioned as a "code snippets collection" for studying architecture, not a runnable complete app.

**Targets**: Intermediate to senior iOS engineers who want to see `CTMediator + MVVM + RxSwift` in a real project.

**Author**: [yangKJ](https://github.com/yangKJ) · **License**: MIT

> 📖 [Full English README](README.en.md) for the complete version.

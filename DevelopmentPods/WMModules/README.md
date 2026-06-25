# WMModules

> 业务模块层 —— 演示如何把真实业务（"发现" / "我的"）按 MPlanet 组件化思路组织。

## 包含的模块

| 模块 | 定位 | 入口 VC | ViewModel |
|---|---|---|---|
| [WMDiscover](WMDiscover/README.md) | 「发现」页 | `DiscoverViewController` | `DiscoverViewModel` |
| [WMMine](WMMine/README.md) | 「我的」页 | `MineViewController` | `MineViewModel` |

## 设计原则

- **业务模块之间不直接 import**，通过 `Mediator` 通信
- **每个业务模块都包含完整的 MVC 骨架**（VC + VM + Cell + API + Target）
- **业务模块复用** `FeatBox` / `Networks` / `Componets` / `ProductLib` 的基础设施
- **Target_xxx 类作为对外门面**，唯一注册入口

## 如何新增一个业务模块

1. 在 `DevelopmentPods/WMModules/` 下新建目录，例如 `Wallet/`
2. 参考 `WMDiscover` 的目录结构：
   ```
   Wallet/
   ├── Classes/
   │   ├── Controller/
   │   ├── ViewModel/
   │   ├── View/ (Cells)
   │   ├── Model/
   │   ├── Util/
   │   │   ├── WalletAPI.swift
   │   │   └── WalletTarget.swift  ←  对外门面
   │   └── ...
   └── Resources/
   ```
3. 在 `Podfile` 中加 `pod 'Wallet', :path => 'DevelopmentPods/WMModules/Wallet'`
4. 在 `Mediator` 中注册 Target 类（自动反射，无需注册）
5. 从其他模块调用：`Mediator.shared.perform(targetName: "Wallet", actionName: "viewController")`

## 路由暴露

业务模块通过 `Target_<ModuleName>` 类暴露给 Mediator：

```swift
// WMDiscover/.../Util/DiscoverTarget.swift
@objc public final class DiscoverTarget: NSObject {
    @objc public func Action_viewController(_ params: [String: Any]?) -> UIViewController {
        return DiscoverViewController()
    }
}
```

调用方通过 `Mediator.perform` 反射调用，**无需 import** 目标模块。

## 数据流

```
VC (输入事件)
  ↓ viewModel.input.didTapButton.onNext()
VM (业务逻辑)
  ↓ API 调用 / 本地计算
VM.output.items.onNext([Model])
  ↓ viewModel.output.items.bind(to: tableView.rx.items(...))
VC (UI 渲染)
```

详见 [`ARCHITECTURE.md`](../../ARCHITECTURE.md)。

## 维护者

[yangKJ](https://github.com/yangKJ)

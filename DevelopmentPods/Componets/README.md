# Componets

> 通用 UI 组件库 —— 提供跨业务复用的视图控件，覆盖圆角按钮、进度条、截屏防护、搜索栏、水波纹效果。

[![Platform](https://img.shields.io/badge/platform-iOS%2015%2B-blue)]()
[![Swift](https://img.shields.io/badge/Swift-5.9%2B-orange)]()
[![License](https://img.shields.io/badge/license-MIT-lightgrey)]()

## 作用
- 提供一组对 UIKit 的薄封装控件，统一全 App 的视觉与交互细节。
- 重点解决 4 个问题：任意角度圆角按钮、约束驱动的进度条、安全防护（截屏/录屏遮挡）、Metal 水波纹动画。
- 不解决业务列表 Cell 与基础架构问题；列表 Cell 放到业务模块，基础架构放到 `FeatBox`。

## 依赖关系
- **被依赖**：`WMDiscover`、`WMMine` 等业务模块，以及主工程。
- **依赖**：仅 UIKit + Metal，零三方依赖，便于跨模块复用。
- **反向依赖**：业务模块不强制依赖 `Componets`，可独立选择控件实现。

## 文件结构
| 路径 | 作用 |
|------|------|
| `Componets/CCGradientButton.swift` | 任意圆角渐变按钮（支持 4 角独立圆角 + 渐变方向） |
| `Componets/CCProgressView.swift` | 基于 NSLayoutConstraint multiplier 的进度条，零额外绘制 |
| `Componets/CCShadowView.swift` | 通用阴影容器，自动同步 path 避免离屏渲染 |
| `Componets/CCSearchBar.swift` | 风格统一的搜索栏，支持 placeholder 动画 |
| `Componets/CCTextField.swift` | 带浮动 Label 与字数限制的输入框 |
| `Componets/CCShieldView.swift` | 截屏 / 录屏防护遮罩，敏感页 onAppear 挂载 |
| `Componets/RippleEffectView.swift` | Metal 驱动的水波纹动画视图 |
| `Componets/RippleEffect.metal` | 上面的 Metal Shading Language 源文件 |

## 使用示例
```swift
// 任意圆角渐变按钮 + 截屏防护
view.addSubview(CCShieldView())                       // 敏感页 onAppear 挂载

let button = CCGradientButton()
button.setCorner([.topLeft: 12, .topRight: 0,
                  .bottomLeft: 0, .bottomRight: 24])  // 4 角独立圆角
button.setGradient([.red.cgColor, .blue.cgColor],
                   direction: .topToBottom)
```

## 维护者
<!-- yangKJ -->
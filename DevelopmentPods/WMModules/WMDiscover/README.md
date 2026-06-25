# WMDiscover

> 「发现」业务模块 —— 演示如何用 MPlanet 组件化架构组织一个真实业务。

[![Platform](https://img.shields.io/badge/platform-iOS%2015%2B-blue)]()
[![Swift](https://img.shields.io/badge/Swift-5.9%2B-orange)]()
[![License](https://img.shields.io/badge/license-MIT-lightgrey)]()

## 作用
- 业务模块示例：包含 Banner 轮播、视频分类、装饰 rail、详情页等典型发现页布局。
- 通过 `DiscoverTarget` 对外暴露入口，遵循 `Mediator` 的 Target-Action 协议。
- 不持有跨模块状态，所有数据通过 `Networks` 拉取并缓存到 `BaseViewModel`。

## 依赖关系
- **被依赖**：`AppMain`（作为 TabBar item）、其他模块跳转进入。
- **依赖**：`FeatBox`（基类 / Rx / 路由）、`Networks`（API）、`Mediator`（`performTarget`）、`Componets`（Cell 内 UI 控件）。
- **反向依赖**：禁止 `WMDiscover` 直接 `import WMMine` 等其他业务模块，必须走 `Mediator`。

## 包含的页面
| 页面 | 文件 | 说明 |
|---|---|---|
| DiscoverViewController | `Sources/Classes/Controller/DiscoverViewController.swift` | 发现页主入口，多 Section 列表 |
| BannerDetailViewController | `Sources/Classes/Controller/BannerDetailViewController.swift` | Banner 详情页（接收 `index` / `banners` 参数） |

## ViewModel
| ViewModel | 文件 | 说明 |
|---|---|---|
| DiscoverViewModel | `Sources/Classes/ViewModel/DiscoverViewModel.swift` | `Observable.zip` 合并 banner + discover 两个接口 |
| BannerDetailViewModel | `Sources/Classes/ViewModel/BannerDetailViewModel.swift` | 详情页数据流 + 当前 index 同步 |

## Cell / Header
| Cell | 文件 | 用途 |
|---|---|---|
| DiscoverDecorativeRailCell | `Sources/Classes/View/DiscoverDecorativeRailCell.swift` | 装饰性 rail（运营位） |
| DiscoverVideoClassifyCell | `Sources/Classes/View/DiscoverVideoClassifyCell.swift` | 视频分类卡片 |
| DiscoverVideoClassifyHeaderView | `Sources/Classes/View/DiscoverVideoClassifyHeaderView.swift` | 视频分类 section header |
| BannerDetailTopCell | `Sources/Classes/View/BannerDetailTopCell.swift` | 详情页顶部 Banner |
| BannerDetailCell | `Sources/Classes/View/BannerDetailCell.swift` | 详情页正文 Cell |

## Model
| Model | 文件 | 用途 |
|---|---|---|
| Discover | `Sources/Classes/Model/Discover.swift` | 发现页主模型 |
| BannerDetail | `Sources/Classes/Model/BannerDetail.swift` | 详情页模型 |

## API 层
| API | 文件 | 说明 |
|---|---|---|
| DiscoverAPI | `Sources/Classes/Util/DiscoverAPI.swift` | Moya Target 枚举 |
| DiscoverTarget | `Sources/Classes/Util/DiscoverTarget.swift` | Mediator Target 暴露入口 |
| DiscoverUtil | `Sources/Classes/Util/DiscoverUtil.swift` | 业务工具方法 |

## 路由暴露
通过 `Mediator` 暴露给其他模块：
- `DiscoverTarget` / `setupDiscoverViewController`
- `DiscoverTarget` / `bannerDetailViewController:` （参数：`index: Int`, `banners: [Banner]`）

## 使用示例
```swift
// 从 WMMine 跳转到 Discover
let vc = Mediator.performTarget(
    "DiscoverTarget",
    action: "setupDiscoverViewController",
    module: "WMDiscover"
) as? UIViewController
navigationController?.pushViewController(vc, animated: true)

// 从任意模块跳到 Banner 详情（带参）
let detail = Mediator.performTarget(
    "DiscoverTarget",
    action: "bannerDetailViewController:",
    module: "WMDiscover",
    params: ["index": 0, "banners": bannerList]
) as? UIViewController
```

## 维护者
<!-- yangKJ -->
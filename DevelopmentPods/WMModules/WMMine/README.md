# WMMine

> 「我的」业务模块 —— 演示如何用 MPlanet 组件化架构组织一个真实业务（用户主页 / 设置 / 签到日历）。

[![Platform](https://img.shields.io/badge/platform-iOS%2015%2B-blue)]()
[![Swift](https://img.shields.io/badge/Swift-5.9%2B-orange)]()
[![License](https://img.shields.io/badge/license-MIT-lightgrey)]()

## 作用
- 业务模块示例：用户主页、相册、相册上传、排行榜、签到日历、设置等典型个人中心页面。
- 通过 `MineTarget` 对外暴露入口，遵循 `Mediator` 的 Target-Action 协议。
- 不持有跨模块状态，所有数据通过 `Networks` 拉取；用户登录态通过 `FeatBox.Session` 读取。

## 依赖关系
- **被依赖**：`AppMain`（作为 TabBar item，需登录）、其他模块跳转进入。
- **依赖**：`FeatBox`（基类 / Rx / 路由 / `Session`）、`Networks`（API）、`Mediator`（`performTarget`）、`Componets`（UI 控件）。
- **反向依赖**：禁止 `WMMine` 直接 `import WMDiscover` 等其他业务模块，必须走 `Mediator`。

## 包含的页面
| 页面 | 文件 | 说明 |
|---|---|---|
| MineViewController | `Sources/Classes/Controller/MineViewController.swift` | 我的主页（Header + 多个 section），可接收 `userId` |
| MineSettingViewController | `Sources/Classes/Controller/MineSettingViewController.swift` | 设置页（功能表 + 退出登录） |
| MineSignatureViewController | `Sources/Classes/Controller/MineSignatureViewController.swift` | 签名编辑页（调用 `FeatBox.SignatureViewController`） |

## ViewModel
| ViewModel | 文件 | 说明 |
|---|---|---|
| MineViewModel | `Sources/Classes/ViewModel/MineViewModel.swift` | 用户信息 + 照片流 + 排行榜 + 签到流合并（多个 `PublishRelay` 入口） |
| MineSettingViewModel | `Sources/Classes/ViewModel/MineSettingViewModel.swift` | 设置项数据源 |

## Cell / Header
| Cell | 文件 | 用途 |
|---|---|---|
| MineUsersHeaderCell | `Sources/Classes/View/MineUsersHeaderCell.swift` | 用户头部信息（头像 / 昵称 / 签名） |
| MineUsersPostsCell | `Sources/Classes/View/MineUsersPostsCell.swift` | 用户帖子列表 Cell |
| MineUsersPhotoCell | `Sources/Classes/View/MineUsersPhotoCell.swift` | 9 宫格照片 Cell |
| MineUsersRankingCell | `Sources/Classes/View/MineUsersRankingCell.swift` | 排行榜 Cell |
| MineSignInCalenderCell | `Sources/Classes/View/MineSignInCalenderCell.swift` | 签到日历 Cell |

## Model
| Model | 文件 | 用途 |
|---|---|---|
| MineUsers | `Sources/Classes/Model/MineUsers.swift` | 用户主模型 |
| MinePostsDetail | `Sources/Classes/Model/MinePostsDetail.swift` | 帖子详情 |
| MinePhotoAlbum | `Sources/Classes/Model/MinePhotoAlbum.swift` | 相册模型 |
| MineSignInCalenderDTO | `Sources/Classes/Model/MineSignInCalenderDTO.swift` | 签到日历 DTO |

## API 层
| API | 文件 | 说明 |
|---|---|---|
| MineAPI | `Sources/Classes/Util/MineAPI.swift` | Moya Target 枚举（用户信息 / 帖子 / 相册 / 排行 / 签到） |
| MineTarget | `Sources/Classes/Util/MineTarget.swift` | Mediator Target 暴露入口 |
| MineUtil | `Sources/Classes/Util/MineUtil.swift` | 业务工具方法 |
| MineFunctionForm | `Sources/Classes/Util/MineFunctionForm.swift` | 我的页面功能表单配置（基于 `Routerable`） |

## 路由暴露
通过 `Mediator` 暴露给其他模块：
- `MineTarget` / `setupMineViewController:` （参数：`userId: String?`）
- `AppMain` 内部会通过 `LoginAuthVerfication` 守护首次进入

## 使用示例
```swift
// 从任意模块拉起「我的」TabBar（带 userId）
let mine = Mediator.performTarget(
    "MineTarget",
    action: "setupMineViewController:",
    module: "WMMine",
    params: ["userId": "10086"]
) as? UIViewController

// 通过 MediatorExt 语义化方法（FeatBox / Mediator 提供）
let mine2 = Mediator.mineTabBarViewController(userId: currentUser.id)
```

## 维护者
<!-- yangKJ -->
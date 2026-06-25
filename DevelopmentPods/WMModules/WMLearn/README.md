# WMLearn

> 「寻音星球 - 学习区」业务模块 —— 音乐学习 6 大分类（钢琴 / 作曲 / 声乐 / 吉他 / 贝斯 / 混音）+ 课程详情 + 世界排行榜（柱状图）。

[![Platform](https://img.shields.io/badge/platform-iOS%2015%2B-blue)]()
[![Swift](https://img.shields.io/badge/Swift-5.9%2B-orange)]()
[![License](https://img.shields.io/badge/license-MIT-lightgrey)]()

## 作用
- 业务模块示例：学习 Tab 主入口（6 宫格）、分类课程列表、课程详情、世界排行榜（柱状图 + 视频赔价榜）。
- 通过 `LearnTarget` 对外暴露入口，遵循 `Mediator` 的 Target-Action 协议。
- 所有接口使用 mock JSON 数据（`stubBehavior = .delayed` + `Resources` bundle 显式 `forResource: "WMLearn"`），保证无网络情况下也可演示完整交互。

## 依赖关系
- **被依赖**：`AppMain`（作为 TabBar item）、其他模块跳转进入。
- **依赖**：`FeatBox`（基类 / Rx / 路由）、`Networks`（API）、`Mediator`（`performTarget`）、`Componets`（Cell 内 UI 控件）。
- **反向依赖**：禁止 `WMLearn` 直接 `import WMDiscover` 等其他业务模块，必须走 `Mediator`。

## 包含的页面
| 页面 | 文件 | 说明 |
|---|---|---|
| LearnViewController | `Sources/Classes/Controller/LearnViewController.swift` | 学习区首页（6 宫格 + 视频赔价榜入口） |
| LearnCategoryViewController | `Sources/Classes/Controller/LearnCategoryViewController.swift` | 分类课程列表（接收 `categoryId`） |
| LearnCourseViewController | `Sources/Classes/Controller/LearnCourseViewController.swift` | 课程详情页（接收 `courseId`） |
| LearnRankingViewController | `Sources/Classes/Controller/LearnRankingViewController.swift` | 世界排行榜（柱状图 + 列表） |

## ViewModel
| ViewModel | 文件 | 说明 |
|---|---|---|
| LearnViewModel | `Sources/Classes/ViewModel/LearnViewModel.swift` | 首页 6 宫格 + 视频赔价榜数据组装 |
| LearnCategoryViewModel | `Sources/Classes/ViewModel/LearnCategoryViewModel.swift` | 分类课程列表 |
| LearnCourseViewModel | `Sources/Classes/ViewModel/LearnCourseViewModel.swift` | 课程详情 |
| LearnRankingViewModel | `Sources/Classes/ViewModel/LearnRankingViewModel.swift` | 排行榜数据 |

## Cell / Header
| Cell | 文件 | 用途 |
|---|---|---|
| LearnCategoryCell | `Sources/Classes/View/LearnCategoryCell.swift` | 6 宫格分类入口 |
| LearnCourseCell | `Sources/Classes/View/LearnCourseCell.swift` | 课程列表 Cell |
| LearnRankingBarCell | `Sources/Classes/View/LearnRankingBarCell.swift` | 排行榜柱状图 Cell |
| LearnVideoCardCell | `Sources/Classes/View/LearnVideoCardCell.swift` | 视频赔价榜 Cell |

## Model
| Model | 文件 | 用途 |
|---|---|---|
| LearnCategory | `Sources/Classes/Model/LearnCategory.swift` | 学习分类 |
| LearnCourse | `Sources/Classes/Model/LearnCourse.swift` | 课程 + 章节 |
| LearnRanking | `Sources/Classes/Model/LearnRanking.swift` | 排行榜用户 |

## API 层
| API | 文件 | 说明 |
|---|---|---|
| LearnAPI | `Sources/Classes/Util/LearnAPI.swift` | Moya Target 枚举（categories/courses/courseDetail/ranking/videos） |
| LearnTarget | `Sources/Classes/Util/LearnTarget.swift` | Mediator Target 暴露入口 |
| LearnUtil | `Sources/Classes/Util/LearnUtil.swift` | 业务工具方法 |

## 路由暴露
通过 `Mediator` 暴露给其他模块：
- `LearnTarget` / `Action_viewController` （学习区首页，无参）
- `LearnTarget` / `Action_categoryViewController:` （分类课程列表，参数：`categoryId: Int`）
- `LearnTarget` / `Action_courseViewController:` （课程详情，参数：`courseId: Int`）
- `LearnTarget` / `Action_rankingViewController` （世界排行榜，无参）

## 使用示例
```swift
// 从其他模块跳到学习区首页
let vc = Mediator.performTarget(
    "LearnTarget",
    action: "Action_viewController",
    module: "WMLearn"
) as? UIViewController
navigationController?.pushViewController(vc, animated: true)

// 跳转到指定分类（带参）
let category = Mediator.performTarget(
    "LearnTarget",
    action: "Action_categoryViewController:",
    module: "WMLearn",
    params: ["categoryId": 1]
) as? UIViewController
navigationController?.pushViewController(category, animated: true)

// 跳转到课程详情（带参）
let course = Mediator.performTarget(
    "LearnTarget",
    action: "Action_courseViewController:",
    module: "WMLearn",
    params: ["courseId": 101]
) as? UIViewController

// 跳转到世界排行榜
let ranking = Mediator.performTarget(
    "LearnTarget",
    action: "Action_rankingViewController",
    module: "WMLearn"
) as? UIViewController
```

## 维护者
<!-- yangKJ -->
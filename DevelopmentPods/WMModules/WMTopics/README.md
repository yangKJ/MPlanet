# WMTopics

寻音星球 - 主题/帖子模块

## 功能

- 主题 Tab：帖子流（最新/热门/我的关注）
- 帖子详情页：完整内容 + 评论区 + 评论输入框
- 基于 MVVM + RxSwift 的 CTMediator 路由

## 目录结构

```
WMTopics/
├── WMTopics.podspec
└── Sources/
    ├── Classes/
    │   ├── Controller/
    │   ├── ViewModel/
    │   ├── View/
    │   ├── Model/
    │   └── Util/
    └── Assets/
```

## CTMediator 路由

- `TopicsTarget.Action_viewController:` -> 主题列表
- `TopicsTarget.Action_detailViewController:` -> 帖子详情（params: id）

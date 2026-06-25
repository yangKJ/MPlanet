# WMChat

寻音星球 - 消息模块

## 功能

- 消息 Tab：会话列表（头像 + 用户名 + 最后消息 + 未读红点 + 时间）
- 基于 MVVM + RxSwift 的 CTMediator 路由

## 目录结构

```
WMChat/
├── WMChat.podspec
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

- `ChatTarget.Action_viewController:` -> 消息列表

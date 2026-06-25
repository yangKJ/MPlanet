# 更新日志 · Changelog

> 本项目所有重要变更都会记录在此文件。格式遵循 [Keep a Changelog](https://keepachangelog.com/zh-CN/1.1.0/)。
> 版本号遵循 [Semantic Versioning](https://semver.org/lang/zh-CN/)。

---

## [0.6.0] - 2026-06-24

### Added
- 新增 `CHANGELOG.md` 项目级版本变更记录
- 新增 `FAQ.md` 常见问题汇总(15+ 条)
- 新增 `ARCHITECTURE.md` 架构走读与设计原则说明
- 新增 `DESIGN.md` 12+ 条 ADR 决策记录
- 新增 `SECURITY.md` 安全策略与 fork 提示
- 新增 `CODE_OF_CONDUCT.md` 社区行为准则
- 新增 `README.en.md` 完整英文版镜像
- 新增 GitHub Actions CI workflow(`.github/workflows/ci.yml`)
- 新增 SwiftLint 与 SwiftFormat 配置文件

### Changed
- 重写 `CONTRIBUTING.md`,由「不接受 PR」改为「欢迎贡献」
- 重写全部 10 个子 pod 的 README,删除 CocoaPods 模板痕迹
- `CommonView` 模块更名为 `Componets`,统一命名风格
- 调整目录结构,所有代码统一到 `Sources/Classes/` 路径
- 优化 `WMTabBarController` 在登录态切换时的插入/移除逻辑
- 优化 `Mediator` 参数预处理的 Swift 结构体兼容分支

### Fixed
- 修复 `Mediator` 无参 VC 缓存在多次 deeplink 触发下偶发的 key 冲突
- 修复 `BaseViewModel` 在 dispose 后仍发出 loading 通知的问题
- 修复 `WMTabBarController.viewDidAppear` 在子 VC 为空时的崩溃
- 修复 `Bridge` 在 `openURL:` 多代理链下返回值判断错误
- 修复 `FeatBox.Routerable` 在缺少 `gotoType` 时的隐式成功返回

### Removed
- 移除 CommonView 模块冗余的 `.gitignore` 与 `.travis.yml`
- 移除 10 个子 pod README 中的个人邮箱 / CI Status / Version / Platform 模板徽章
- 移除 Pod 模板自带的 `your-username` / `your_email` 等占位符

### Security
- 全仓库敏感信息脱敏(API key / Apple ID / 内部域名)
- `Podfile` 中私有源仓库地址替换为占位符

---

## [0.5.0] - 2025-12-10

### Added
- 新增 `WMModules/` 业务模块聚合,统一注册到 `Mediator`
- 新增 `RippleEffectView` + `RippleEffect.metal` GPU 渲染骨架
- 新增 `CCShieldView` 截屏防护组件
- 新增 `MineFunctionForm` 我的页面表单配置化能力

### Changed
- 将 `WMMine` / `WMDiscover` 拆分为独立 pod,降低宿主工程耦合
- `Bridge` 拆分为 Configs / Root / Launcher / GotoHome 四段责任链
- `BaseViewModel` 改为基于 `Rickenbacker` 协议,统一订阅生命周期

### Fixed
- 修复 `Mediator` 在 Swift 结构体参数上的反射丢失
- 修复 `FunctionType` 在 `goto(from:)` 缺少来源 VC 时的栈顶推断错误

---

## [0.4.0] - 2025-08-15

### Added
- 新增 `@UserDefault_` 属性包装器,支持自定义默认值与类型
- 新增 `Wrapper.fy` 命名空间协议(`String.fy.trim`、`UIColor.fy.xxx`)
- 新增 `@dynamicMemberLookup` 字典链式访问 (`JSONCatcher` / `Reference`)
- 新增协议 + Associated Object 的 holder 模式 (`AuthVerficationable`)

### Changed
- `ProductLib` 重构,所有工具类统一走 `fy` 命名空间
- `FeatBox` 引入 `Routerable` 协议,Model 直接具备跳转能力

### Fixed
- 修复 `UserDefault_` 在可选类型下的默认值丢失
- 修复 `Mirror` 反射在嵌套 struct 上的死循环

---

## [0.3.0] - 2025-04-02

### Added
- 新增 `Database` 模块,封装 WCDB 的增删改查 + 表管理
- 新增 `FeatBox.Notify` Rx 化通知中心,统一业务事件总线
- 新增 `AppMainUtil.standardTabBarItems` TabBar 配置静态化
- 新增 `HBDNavigationBar` 全局导航栏样式

### Changed
- 网络层切到 `RxNetworks`,支持 10 款插件(cache / log / indicator ...)
- 引入 `RxDataSources` 多 section 数据源

### Fixed
- 修复 `ESTabBarController` 在 iOS 16 上的 KVO 警告
- 修复 `RxNetworks` 缓存插件在内存压力下的崩溃

---

## [0.2.0] - 2024-12-20

### Added
- 新增 `RootManager.Bridge` 拆分巨型 AppDelegate
- 新增 `LauncherAppDelegate` 启动流程独立配置
- 新增 `ConfigsAppDelegate` 第三方 SDK 注册统一入口
- 新增 `Mourning` 悼念模式(`saturationBlendMode` 灰度覆盖)

### Changed
- `MainProject.AppDelegate` 改为 Bridge 容器,仅 30 行
- `Mediator` 增加参数预处理与 action 冒号自动补齐

### Fixed
- 修复 AppDelegate 多代理链 `openURL` 返回值被吞掉

---

## [0.1.0] - 2024-09-01

### Added
- 项目初始化,搭建 10 个本地子 pod 的组件化骨架
- 集成 CocoaPods 1.13+,Podfile 改用清华镜像源
- `Mediator` Target-Action 路由第一版,基于 `__objc_performSelector`
- `FeatBox.Routerable` 协议驱动跳转
- `AppMain.WMTabBarController` 动态 TabBar
- 接入 RxSwift 6.x + RxCocoa + RxDataSources
- 接入 SnapKit / Alamofire / Moya / Lottie / MJRefresh
- 接入 Rickenbacker / RxNetworks / Harbeth / ImageX 自研库

### Security
- 初始版本基于 MIT License 开源

---

## 版本号说明

| 类型 | 触发条件 | 示例 |
|---|---|---|
| **Major**(`x.0.0`) | 架构级别重构 / 不向后兼容的改动 | `1.0.0` |
| **Minor**(`0.x.0`) | 新增功能 / 模块,向后兼容 | `0.6.0` |
| **Patch**(`0.0.x`) | Bug 修复 / 文档 / 优化 | `0.6.1` |

---

## 链接

- 📘 [Keep a Changelog 1.1.0](https://keepachangelog.com/zh-CN/1.1.0/)
- 🏷️ [Semantic Versioning 2.0.0](https://semver.org/lang/zh-CN/)
- 📋 [Conventional Commits](https://www.conventionalcommits.org/zh-hans/)

---

<div align="center">

[⬆ 回到顶部](#更新日志--changelog)

</div>
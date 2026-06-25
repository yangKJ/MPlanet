<div align="center">

# MPlanet

### Battle-Tested iOS Modularization Template · CTMediator + MVVM + RxSwift

> **A production-grade iOS modularization template after 4 years of real-world practice.**
> Readable source code, not slides. ~17K lines of Swift, ready to learn and modify.

[![License](https://img.shields.io/badge/license-MIT-blue.svg)](LICENSE)
[![Platform](https://img.shields.io/badge/platform-iOS%2015%2B-lightgrey.svg)](#-requirements)
[![Swift](https://img.shields.io/badge/Swift-5.9%2B-orange.svg)](#-requirements)
[![Xcode](https://img.shields.io/badge/Xcode-15%2B-blue.svg)](#-requirements)
[![Architecture](https://img.shields.io/badge/architecture-CTMediator%20%2B%20MVVM%20%2B%20RxSwift-green.svg)](#-architecture)
[![CocoaPods](https://img.shields.io/badge/CocoaPods-1.13%2B-red.svg)](#-quick-start)

> **Languages:** [🇨🇳 简体中文](README.md) · [🇬🇧 **English**](#)

</div>

---

## Why This Project?

**MPlanet** is a **production-grade iOS modularization template** that actually strings together the most popular technologies in real iOS teams:

- **Component Architecture** — 10 local CocoaPods pods, all decoupled
- **Mediator Routing** — `__objc_performSelector` reflection, no URL registration
- **Reactive MVVM** — RxSwift + RxCocoa + RxDataSources driving data flow
- **4 Self-Developed Base Libraries** — Rickenbacker, RxNetworks, Harbeth, ImageX
- **Engineering Practices** — Bridge pattern AppDelegate, dynamic TabBar, namespace protocol, property wrappers, dynamic member lookup
- **GPU Rendering** — MTKView + custom `.metal` shaders for ripple effect

**~17,000 lines of Swift + 1,000 lines of ObjC** — a complete skeleton of a real medium-sized iOS project.

> ⚠️ Positioned as a **"code snippets collection"** for studying architecture, not a runnable complete app. Business modules are demo-grade; **the real value is in the architecture and patterns**.

---

## Core Highlights

### 1. Component Architecture
- ✅ Pure host project + 10 local pods with `:path` references
- ✅ All modules decoupled; pods don't cross-import each other
- ✅ `Mediator` (CTMediator-style) — `__objc_performSelector` reflection
- ✅ `Routerable` protocol — any model conforming gets a `.goto()` method
- ✅ Dynamic TabBar insertion/removal on login state change

### 2. Reactive MVVM
- ✅ RxSwift + RxCocoa + RxDataSources
- ✅ `Observable.zip` to merge multiple endpoints
- ✅ `BaseViewModel` standardizes loading/error/empty
- ✅ `BaseTableViewModel` protocol-driven list data sources
- ✅ `Session` singleton + Notification two-way binding

### 3. Network Layer
- ✅ Moya + RxSwift encapsulation
- ✅ Plugin architecture: Cache / Loading / Header / Files
- ✅ `ApiResponse<T>` generic response shell

### 4. Custom UI Components
- ✅ `CCProgressView` — `NSLayoutConstraint.setMultiplier` rewrite
- ✅ `CCShieldView` — screenshot protection (via `isSecureTextEntry`)
- ✅ `CCGradientButton` — `CAGradientLayer` + `CAShapeLayer` arbitrary rounded corners
- ✅ `RippleEffectView` — Metal-rendered click ripple

### 5. Advanced Swift Syntax
- ✅ `@propertyWrapper` — `@UserDefault_`
- ✅ `@dynamicMemberLookup` — `JSONCatcher` / `Reference`
- ✅ Namespace protocol — `Wrapper.fy.xxx`
- ✅ Operator overloading, custom subscripts, generic protocols

### 6. Engineering
- ✅ `AppDelegate` Bridge pattern decomposition
- ✅ Mourning mode (saturation filter overlay)
- ✅ Launch screen + root controller switching
- ✅ iOS 15+ minimum deployment, Swift 5.9+

---

## Architecture Overview

```
┌──────────────────────────────────────┐
│  MainProject (AppDelegate + Bridge)  │
└──────────────┬───────────────────────┘
               │ Launch / Route
    ┌──────────┼──────────┐
    ▼          ▼          ▼
┌────────┐ ┌────────┐ ┌────────┐
│AppMain │ │WMDisc. │ │WMMine  │
│(TabBar)│ │ Discover│ │ Mine  │
└────┬───┘ └────┬───┘ └────┬───┘
     │          │          │
     │    Mediator (Target-Action) │
     │          │          │
     └──────────┼──────────┘
                │
    ┌───────────┼───────────┐
    ▼           ▼           ▼
┌────────┐ ┌────────┐ ┌────────┐
│FeatBox │ │Networks│ │Database│
└────┬───┘ └────┬───┘ └────┬───┘
     │          │          │
     └──────────┼──────────┘
                ▼
        ┌────────────┐  ┌──────────┐
        │ ProductLib │  │Componets │
        └────────────┘  └────┬─────┘
                             ▼  Metal
                       ┌────────────┐
                       │RippleEffect│
                       │  + .metal  │
                       └────────────┘
```

### Call Chain Example

```swift
// WMMine wants to jump to WMDiscover's BannerDetail
discoverModel.goto(.bannerDetail(id: "123"))
  → Routerable.goto(.bannerDetail(id))
  → Mediator.perform("WMDiscover", "bannerDetailViewController", params: ["id": id])
  → __objc_performSelector("Target_WMDiscover", "Action_bannerDetailViewController:")
  → WMDiscover.Target_WMDiscover creates BannerDetailViewController
  → Cached + returned to caller
```

---

## Tech Stack

### Core Architecture
| Tech | Use | Source |
|---|---|---|
| **RxSwift / RxCocoa** | Reactive programming | [ReactiveX](https://github.com/ReactiveX/RxSwift) |
| **Moya** | Network abstraction | [Moya/Moya](https://github.com/Moya/Moya) |
| **SnapKit** | Auto Layout DSL | [SnapKit/SnapKit](https://github.com/SnapKit/SnapKit) |
| **RxDataSources** | Multi-section data sources | [RxSwiftCommunity/RxDataSources](https://github.com/RxSwiftCommunity/RxDataSources) |

### Self-Developed Base Libraries
| Lib | Responsibility | Repo |
|---|---|---|
| **Rickenbacker** | Base architecture (BaseVC / BaseVM / refresh / empty) | [yangKJ/Rickenbacker](https://github.com/yangKJ/Rickenbacker) |
| **RxNetworks** | Network layer + 10 plugins | [yangKJ/RxNetworks](https://github.com/yangKJ/RxNetworks) |
| **Harbeth** | Metal image / video filters | [yangKJ/Harbeth](https://github.com/yangKJ/Harbeth) |
| **ImageX** | Image / GIF framework | [yangKJ/ImageX](https://github.com/yangKJ/ImageX) |

### Third-Party UI & Tools
- **Alamofire** — HTTP client (Moya backend)
- **Lottie** — Vector animations
- **MBProgressHUD / MJRefresh** — HUD / refresh
- **HBDNavigationBar** — Navigation bar styling
- **ESTabBarController** — TabBar container
- **DZNEmptyDataSet** — Empty data set
- **FSCalendar / FSPagerView** — Calendar / carousel

---

## Directory Structure

```
MPlanet/
├── MainProject/                          # Host project
│   ├── AppDelegate.swift                 # Bridge pattern entry
│   └── Info.plist
│
├── DevelopmentPods/
│   ├── AppMain/                          # TabBar + launch
│   ├── Componets/                        # UI components
│   │   ├── CCProgressView                # Layout multiplier rewrite
│   │   ├── CCShieldView                  # Screenshot protection
│   │   ├── CCGradientButton              # Arbitrary rounded corners
│   │   ├── RippleEffectView + .metal     # Metal rendering
│   │   └── ...
│   ├── Database/                         # WCDB wrapper
│   ├── FeatBox/                          # Base capabilities
│   │   ├── Core/                         # Routerable / FunctionType / Session
│   │   ├── Base/                         # BaseVC / BaseVM / BaseTableVC
│   │   └── Verfication/                  # AuthVerificationable
│   ├── Mediator/                         # Component routing
│   ├── Networks/                         # Network layer
│   ├── ProductLib/                       # Common utilities
│   ├── RootManager/                      # AppDelegate decomposition
│   └── WMModules/
│       ├── WMDiscover/                   # "Discover" module
│       └── WMMine/                       # "Mine" module
│
├── Podfile
├── Podfile.lock
├── LICENSE
├── CONTRIBUTING.md
└── README.en.md  (👈 you are here)
```

---

## Learning Path

> Read in this order, you'll grasp the whole architecture in ~2-3 hours.

### Phase 1: Entry Point (30 min)
1. ⭐ **AppDelegate Bridge** — [`MainProject/AppDelegate.swift`](MainProject/AppDelegate.swift) · [`RootManager/Bridge.swift`](DevelopmentPods/RootManager/RootManager/Classes/Bridge.swift)

### Phase 2: Componentization (45 min)
2. ⭐ **Mediator Routing** — [`Mediator/MediatorExt.swift`](DevelopmentPods/Mediator/Mediator/Classes/MediatorExt.swift)
3. ⭐ **Routerable Protocol** — [`FeatBox/Routerable.swift`](DevelopmentPods/FeatBox/FeatBox/Core/Routerable.swift) · `FunctionType.swift`

### Phase 3: MVVM + Container (45 min)
4. ⭐ **Dynamic TabBar** — [`AppMain/WMTabBarController.swift`](DevelopmentPods/AppMain/AppMain/Classes/WMTabBarController.swift)
5. **BaseViewModel** — [`FeatBox/BaseViewModel.swift`](DevelopmentPods/FeatBox/FeatBox/Base/BaseViewModel.swift)
6. **MVVM In Action** — [`WMDiscover/DiscoverViewModel.swift`](DevelopmentPods/WMModules/WMDiscover/WMDiscover/Classes/ViewModel/DiscoverViewModel.swift)

### Phase 4: Advanced Swift (45 min)
7. ⭐ **Property Wrapper** — [`ProductLib/UserDefaults.swift`](DevelopmentPods/ProductLib/ProductLib/Classes/UserDefaults.swift)
8. ⭐ **Namespace Protocol** — [`ProductLib/Wrapper.swift`](DevelopmentPods/ProductLib/ProductLib/Classes/Wrapper.swift)
9. ⭐ **@dynamicMemberLookup** — [`ProductLib/JSONCatcher.swift`](DevelopmentPods/ProductLib/ProductLib/Classes/JSONCatcher.swift) · `Reference.swift`

### Phase 5: GPU Rendering (30 min)
10. ⭐ **Metal Skeleton** — [`Componets/RippleEffectView.swift`](DevelopmentPods/Componets/Componets/RippleEffectView.swift) + `RippleEffect.metal`

---

## Quick Start

```bash
git clone https://github.com/yangKJ/MPlanet.git
cd MPlanet
pod install
open MainProject.xcworkspace
```

> The repo doesn't include `Pods/`. Run `pod install` to fetch dependencies.

## Requirements

- Xcode 15+
- iOS 15+
- Swift 5.9+
- CocoaPods 1.13+

---

## Documentation

- 🏛️ [Architecture Deep Dive (中文)](ARCHITECTURE.md) — Layered diagram + complete call chain walkthrough
- 💡 [Design Decisions (ADR)](DESIGN.md) — 13 technical decision records
- ❓ [FAQ (中文)](FAQ.md) — 15+ Q&A
- 📝 [Changelog (中文)](CHANGELOG.md) — Keep a Changelog format
- 🔒 [Security Policy (中文)](SECURITY.md) · [Code of Conduct (中文)](CODE_OF_CONDUCT.md) · [Contributing (中文)](CONTRIBUTING.md)

---

## Contributing

This project **does NOT accept code PRs** (single-maintainer). See [CONTRIBUTING.md (中文)](CONTRIBUTING.md) for details. Forks welcome.

---

## License

MIT — see [LICENSE](LICENSE).

---

## About the Author

Created and open-sourced by [yangKJ](https://github.com/yangKJ).

Other open-source projects by the same author (deeply integrated with MPlanet):

| Lib | Positioning | Repo |
|---|---|---|
| **Rickenbacker** | RxSwift base architecture | [github.com/yangKJ/Rickenbacker](https://github.com/yangKJ/Rickenbacker) |
| **RxNetworks** | Moya + RxSwift network layer | [github.com/yangKJ/RxNetworks](https://github.com/yangKJ/RxNetworks) |
| **Harbeth** | Metal image / video filters | [github.com/yangKJ/Harbeth](https://github.com/yangKJ/Harbeth) |
| **ImageX** | Image / GIF framework | [github.com/yangKJ/ImageX](https://github.com/yangKJ/ImageX) |

---

## Acknowledgments

Architecture ideas adapted from:
- [MGJRouter](https://github.com/lyujunwei/MGJRouter) — URL-based routing
- [CTMediator](https://github.com/casatwy/CTMediator) — ObjC runtime Mediator (the chosen approach)

Thanks to all the open-source projects that made this possible.

---

> **Maintainer:** Single-maintainer project. Response delays are normal. ❤️

//
//  Storyboardable.swift
//  ProductLib
//
//  Created by Agent Z on 2024/5/24.
//
//  用于替代分散的 `required init?(coder:) { fatalError(...) }` 实现。
//  使用 Storyboardable 后,只需要让 UIView/UIViewController 子类继承该 protocol,
//  Xcode/Interface Builder 仍然能识别 `init?(coder:)`,但运行期直接走统一报错路径,
//  减少重复代码与不一致的 fatalError 字符串。
//

import Foundation

/// 标记协议:任何实现本协议的 `UIView`/`UIViewController` 子类都被认为不支持 Storyboard 加载。
/// Swift 不允许 protocol extension 提供 `required init?` 的默认实现(因为 UIKit 父类标记了 `required`),
/// 所以子类仍然需要显式写一个 `required init?(coder:)` 桩,但 body 内统一调用
/// `StoryboardableFatal.notImplemented(coder:)` 来集中错误处理逻辑,
/// 避免 17+ 处分散的 `fatalError("init(coder:) has not been implemented")`。
public protocol Storyboardable: AnyObject {}

/// 独立 enum namespace,提供统一的 fatalError 入口。
/// 用 enum 而非 protocol extension 是为了让 fatalError 返回类型 `Never` 在
/// 子类 `super.init(coder:)` 之后被编译器正确识别,避免 stored property
/// `not initialized at super.init call` 误报。
public enum StoryboardableFatal {
    @inline(never)
    public static func notImplemented(coder: NSCoder) -> Never {
        fatalError("init(coder:) is not supported for Storyboardable types; use programmatic init instead.")
    }
}

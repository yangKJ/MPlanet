//
//  Once.swift
//  FeatBox
//
//  Created by Condy on 2023/3/14.
//

import Foundation
import Darwin

public final class Once {
    private var lock = os_unfair_lock()
    private var hasRun = false
    private var value: Any?

    /// Executes the given closure only once. (Thread-safe)
    /// Example:
    ///
    ///     func process(_ text: String) -> String {
    ///         return text
    ///     }
    ///     let once = Once()
    ///     let a = once.run { process("a") }
    ///     let b = once.run { process("b") }
    ///     print(a, b) // => "a a"
    /// - Parameter closure: Returns the value that the called closure.
    /// - Returns: Returns the value that the called closure returns the first (and only) time it's called.
    public func run<T>(_ closure: @autoclosure () throws -> T) rethrows -> T {
        os_unfair_lock_lock(&lock)
        defer {
            os_unfair_lock_unlock(&lock)
        }
        guard !hasRun else {
            // 已运行过,缓存值必须能 cast 回当前调用方声明的 T,否则视为 API 误用。
            // 典型错误场景:第一次 run 返回 Int,第二次 run 当成 String,这里直接 fatal 提示。
            guard let cached = value as? T else {
                fatalError("Once.run called with different generic type T. Once.run<T>(...) captures first call's T.")
            }
            return cached
        }
        hasRun = true
        let returnValue = try closure()
        value = returnValue
        return returnValue
    }
    
    /// Wraps an optional single-argument function.
    public func wrap<T, U>(_ function: ((T) -> U)?) -> ((T) -> U)? {
        guard let function else {
            return nil
        }
        return { [self] parameter in
            // `run` 现在是 `@autoclosure`,必须直接传值,
            // 外层 closure 让调用时机推迟到每次触发函数时。
            run(function(parameter))
        }
    }
}

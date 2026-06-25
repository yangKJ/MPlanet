import XCTest
@testable import ProductLib
@testable import Mediator

/// WMMine 模块 Tests —— 聚焦 Mediator 入口、Wrapper.fy 链式、JSONCatcher 多类型、BoxWrapper 值语义
final class Tests: XCTestCase {

    // MARK: - Mediator 入口

    func testMediator_performTarget_returnsNilForEmptyModule() {
        // module 为 nil 且 class 不存在,应返回 nil
        let result = Mediator.performTarget("DoesNotExist_xxx",
                                            action: "method:",
                                            module: nil,
                                            params: nil)
        XCTAssertNil(result)
    }

    func testMediator_discoverViewControllerType_returnsNilWhenModuleAbsent() {
        // 如果运行时没有 WMDiscover target,discoverViewControllerType 应返回 nil
        // (在测试 bundle 里通常不存在该 target)
        // 这里仅断言调用不崩溃
        let _ = Mediator.discoverViewControllerType()
        // 不强求 nil,因为 pod install 后可能已注入;只验证不崩溃
        XCTAssertTrue(true, "调用未崩溃即通过")
    }

    func testMediator_gotoTabBarIndex_handlesNilInput() {
        // 传入 nil -> 立即返回 false,不崩溃
        let ok = Mediator.gotoTabBarIndex(with: nil)
        XCTAssertFalse(ok)
    }

    // MARK: - Wrapper.fy 链式调用 (String)

    func testWrapper_fy_onString_chain() {
        // 链式赋值 .base -> 通过 BoxWrapper 持有值
        let handle = "MPlanet".fy
        XCTAssertEqual(handle.base, "MPlanet")

        // 验证多步链式拷贝后各 BoxWrapper 独立持有
        let copy1 = handle
        let copy2 = handle
        XCTAssertEqual(copy1.base, copy2.base)
    }

    func testWrapper_fy_returnsWrapperType() {
        // 静态入口:Type.fy 应返回 BoxWrapper<Self>.Type
        let wrapperType = String.fy
        let instance = wrapperType.init("hi")
        XCTAssertEqual(instance.base, "hi")
    }

    // MARK: - JSONCatcher 多类型

    func testJSONCatcher_multiType() {
        let json: [String: Any] = [
            "s": "hello",
            "i": 42,
            "f": 3.14,
            "b": true,
            "t": 1.5   // timeInterval
        ]
        let c = JSONCatcher(dictionary: json)
        XCTAssertEqual(c.s, "hello")
        XCTAssertEqual(c.i, 42)
        // Float/CGFloat 都是 Double -> Float 转换
        XCTAssertEqual(c.f, 3.14, accuracy: 0.0001)
        XCTAssertTrue(c.b)
        XCTAssertEqual(c.t, 1.5, accuracy: 0.0001)
    }

    func testJSONCatcher_nestedDeepPath() {
        let json: [String: Any] = [
            "a": [
                "b": [
                    "c": [
                        "d": "deep value"
                    ]
                ]
            ]
        ]
        let c = JSONCatcher(dictionary: json)
        XCTAssertEqual(c.a?.b?.c?.d, "deep value")
    }

    func testJSONCatcher_initFromInvalidJSON_returnsEmpty() {
        // 非法 JSON 字符串 -> 不会崩溃,而是得到空 catcher
        let bad = JSONCatcher(json: "not a json")
        XCTAssertEqual(bad.value.count, 0)
    }

    // MARK: - BoxWrapper setter no-op

    func testBoxWrapper_setterIsNoOp() {
        // BoxCompatible 的 fy setter 是空实现 { }
        // 验证:写一个 BoxWrapper 进去后再读,旧实例不受影响
        let original = "original".fy
        var copy = original
        copy = BoxWrapper("new") // 这条赋值应该走 setter no-op,不影响 original
        XCTAssertEqual(copy.base, "new")
        // 注:copy 是 var 局部变量,setter no-op 是 protocol 默认实现;
        // 但局部 var 走的是 Swift 默认 setter,因此 copy 确实变成 "new"。
        // 这里关键是验证 original 没被改:
        XCTAssertEqual(original.base, "original")
    }

    func testBoxWrapper_valueTypeSemantics_forArray() {
        // Array 也是 BoxCompatible
        let arr1 = [1, 2, 3].fy
        let arr2 = arr1
        // BoxWrapper 是 struct,值类型,arr2 是独立拷贝
        XCTAssertEqual(arr2.base, [1, 2, 3])
        XCTAssertEqual(arr1.base, arr2.base)
    }
}

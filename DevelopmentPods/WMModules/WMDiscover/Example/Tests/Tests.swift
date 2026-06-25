import XCTest
import UIKit
@testable import FeatBox
@testable import ProductLib
@testable import Mediator

/// WMDiscover 模块 Tests —— 聚焦 Routerable 路由派发、Mediator 失败路径、Once 多线程
final class Tests: XCTestCase {

    // MARK: - Routerable 协议行为

    func testRouterable_gotoTypeEnum_mapping() {
        let model = TestRouter(gotoType: "WEB", gotoObject: "https://example.com")
        XCTAssertEqual(model.gotoTypeEnum, .web)

        let model2 = TestRouter(gotoType: "FUNCTION", gotoObject: "openSetting")
        XCTAssertEqual(model2.gotoTypeEnum, .function)

        let model3 = TestRouter(gotoType: "TAB_BAR", gotoObject: "Discover")
        XCTAssertEqual(model3.gotoTypeEnum, .tabBar)

        // 未识别的字符串 -> nil
        let model4 = TestRouter(gotoType: "UNKNOWN", gotoObject: nil)
        XCTAssertNil(model4.gotoTypeEnum)
    }

    func testRouterable_lookup_byAddRemoveContainer() {
        // 模拟一个最小路由注册表:add/remove/lookup 三步
        var table: [String: TestRouter] = [:]

        // add
        table["home"] = TestRouter(gotoType: "WEB", gotoObject: "https://mplanet.dev")
        table["setting"] = TestRouter(gotoType: "FUNCTION", gotoObject: "openSetting")

        XCTAssertEqual(table.count, 2)

        // lookup
        XCTAssertEqual(table["home"]?.gotoTypeEnum, .web)
        XCTAssertEqual(table["setting"]?.gotoObject, "openSetting")

        // remove
        table["home"] = nil
        XCTAssertNil(table["home"])
        XCTAssertEqual(table.count, 1)
    }

    func testRouterable_goto_dispatchesByType() {
        // .none / .url / .applets / .web / .tabBar 都是占位返回 true(由对应 Mediator/外部实现负责)
        // 这里我们只验证 .function 路径:如果 functionType 无法识别,goto 应返回 false
        let bad = TestRouter(gotoType: "FUNCTION", gotoObject: nil)
        XCTAssertFalse(bad.goto())

        // .none 应走默认分支返回 true(空操作)
        let none = TestRouter(gotoType: "NONE", gotoObject: nil)
        XCTAssertTrue(none.goto())
    }

    // MARK: - Mediator 失败路径

    func testMediator_performTarget_unknownClass_returnsNil() {
        // 找一个肯定不存在的 target 名
        let result = Mediator.performTarget("NonexistentTarget_xyz_9999",
                                            action: "noop",
                                            module: "NoSuchModule",
                                            params: nil)
        XCTAssertNil(result, "对不存在的 target,Mediator 应返回 nil 而不崩溃")
    }

    func testMediator_getCacheViewController_unknownClass_returnsNil() {
        let vc = Mediator.getCacheViewController("NonexistentTarget_zzz",
                                                 action: "setup",
                                                 module: "NoSuchModule",
                                                 params: nil)
        XCTAssertNil(vc)
    }

    // MARK: - Once 一次性闭包

    func testOnce_runsExactlyOnce() {
        let once = Once()
        var count = 0
        let a = once.run { count += 1; return "first" }
        let b = once.run { count += 1; return "second" }
        let c = once.run { count += 1; return "third" }

        XCTAssertEqual(a, "first")
        XCTAssertEqual(b, "first", "Once.run 第二次起应返回首次结果")
        XCTAssertEqual(c, "first")
        XCTAssertEqual(count, 1, "底层闭包只应执行一次")
    }

    func testOnce_threadSafety_simulatedWithNSLock() {
        // Once.run 内部用 os_unfair_lock,本身已线程安全。
        // 这里用 NSLock 串行化多组"模拟并发"调用,验证 hasRun 状态不会被打乱。
        let once = Once()
        let lock = NSLock()
        var results: [Int] = []

        // 8 个 worker 同时尝试 run,理论都应该返回同一个值
        let group = DispatchGroup()
        for i in 0..<8 {
            group.enter()
            DispatchQueue.global().async {
                let v = once.run { 100 + i } // 闭包内 i 是首次调用时的值
                lock.lock()
                results.append(v)
                lock.unlock()
                group.leave()
            }
        }
        group.wait()

        XCTAssertEqual(results.count, 8)
        XCTAssertTrue(results.allSatisfy { $0 == results.first }, "所有线程看到的值必须一致")
        XCTAssertGreaterThanOrEqual(results.first ?? 0, 100)
    }

    func testOnce_wrap_cachesOptionalFunction() {
        let once = Once()
        var invocations = 0
        let wrapped: ((Int) -> Int)? = once.wrap { x in
            invocations += 1
            return x * 2
        }

        XCTAssertNotNil(wrapped)
        let r1 = wrapped?(5)
        let r2 = wrapped?(7)
        let r3 = wrapped?(100)
        XCTAssertEqual(r1, 10)
        XCTAssertEqual(r2, 10, "Once.wrap 后只调用一次")
        XCTAssertEqual(r3, 10)
        XCTAssertEqual(invocations, 1)
    }
}

// MARK: - Helpers

struct TestRouter: Routerable {
    var gotoType: String?
    var gotoObject: String?
}

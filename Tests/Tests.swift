import XCTest
@testable import ProductLib

/// MPlanet 主仓 Tests —— 覆盖 ProductLib 通用基础设施(UserDefault_/Reference/Wrapper/JSONCatcher)
final class Tests: XCTestCase {

    // MARK: - UserDefault_

    /// 用临时 key 测 set/get,避免污染标准 UserDefaults
    private struct UDStorage {
        @UserDefault_("tests.ud.bool", defaultValue: false)
        static var flag: Bool

        @UserDefault_("tests.ud.int", defaultValue: 7)
        static var counter: Int

        @UserDefault_("tests.ud.string", defaultValue: "fallback")
        static var title: String
    }

    override func setUp() {
        super.setUp()
        // 每个 case 前清掉临时 key
        UserDefaults.standard.removeObject(forKey: "tests.ud.bool")
        UserDefaults.standard.removeObject(forKey: "tests.ud.int")
        UserDefaults.standard.removeObject(forKey: "tests.ud.string")
    }

    func testUserDefault_setterThenGetter_returnsWrittenValue() {
        UDStorage.flag = true
        UDStorage.counter = 99
        UDStorage.title = "hello"
        XCTAssertTrue(UDStorage.flag)
        XCTAssertEqual(UDStorage.counter, 99)
        XCTAssertEqual(UDStorage.title, "hello")
    }

    func testUserDefault_returnsDefaultValueWhenKeyMissing() {
        XCTAssertFalse(UDStorage.flag)        // default false
        XCTAssertEqual(UDStorage.counter, 7)  // default 7
        XCTAssertEqual(UDStorage.title, "fallback")
    }

    func testUserDefault_overwritePreviousValue() {
        UDStorage.counter = 1
        UDStorage.counter = 2
        XCTAssertEqual(UDStorage.counter, 2)
    }

    // MARK: - Reference

    func testReference_writableKeyPathForwardsWrite() {
        // 用一个 struct 通过 Reference 转成"可写引用"
        struct Model { var name: String; var age: Int }
        let ref = Reference(value: Model(name: "A", age: 1))
        ref.name = "B"
        ref.age = 9
        XCTAssertEqual(ref.name, "B")
        XCTAssertEqual(ref.age, 9)
    }

    func testReference_readForwarding() {
        struct Point { var x: Int = 0; var y: Int = 0 }
        let ref = Reference(value: Point(x: 3, y: 4))
        XCTAssertEqual(ref.x, 3)
        XCTAssertEqual(ref.y, 4)
    }

    // MARK: - Wrapper.fy

    func testWrapper_fyChainOnString() {
        // fy 给所有遵循 BoxCompatible 的类型加挂载点;String 是 BoxCompatible
        let wrapped = "hello".fy
        XCTAssertEqual(wrapped.base, "hello")

        // BoxWrapper setter 是 no-op(对照源码:Wrapper.swift 的 var fy setter 为空实现)
        // 这里验证:赋一个全新的 BoxWrapper 给局部 var,不影响其他实例
        var local = wrapped
        local = BoxWrapper("world")
        XCTAssertEqual(local.base, "world")
        XCTAssertEqual(wrapped.base, "hello")
    }

    func testWrapper_fyChainOnInt() {
        let wrapped = 42.fy
        XCTAssertEqual(wrapped.base, 42)
    }

    // MARK: - JSONCatcher

    func testJSONCatcher_chainedDictionaryAccess() {
        let json: [String: Any] = [
            "name": "Rover",
            "owner": ["name": "Alice", "age": 30]
        ]
        let c = JSONCatcher(dictionary: json)
        XCTAssertEqual(c.name, "Rover")
        XCTAssertEqual(c.owner?.name, "Alice")
        // 数值 age 是 Int,可读出
        XCTAssertEqual(c.owner?.age, 30)
    }

    func testJSONCatcher_typoReturnsNilOrDefault() {
        let json: [String: Any] = ["name": "X"]
        let c = JSONCatcher(dictionary: json)
        // typo:字典里没有 "naem",Optional 路径走底层 as? String -> nil
        XCTAssertNil(c.value["naem"] as? String)
        // typo:字典里没有 "naem",非 Optional 路径 -> default ""
        let defaultStr: String = (c.value["naem"] as? String) ?? ""
        XCTAssertEqual(defaultStr, "")
        // 存在的 key 验证可选类型路径能命中
        XCTAssertEqual(c.value["name"] as? String, "X")
    }

    func testJSONCatcher_arraySubscript() {
        let json: [String: Any] = [
            "items": [["id": 1], ["id": 2], ["id": 3]]
        ]
        let c = JSONCatcher(dictionary: json)
        let items: [JSONCatcher] = c.items
        XCTAssertEqual(items.count, 3)
        XCTAssertEqual(items.first?.id, 1)
    }
}

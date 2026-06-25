# Database

> 数据库工具层 —— 基于腾讯 [WCDB.swift](https://github.com/Tencent/wcdb) 封装的统一增删改查与建表工具。

[![Platform](https://img.shields.io/badge/platform-iOS%2015%2B-blue)]()
[![Swift](https://img.shields.io/badge/Swift-5.9%2B-orange)]()
[![License](https://img.shields.io/badge/license-MIT-lightgrey)]()

## 作用
- 屏蔽 WCDB 的初始化细节，对外暴露 `DBManager` 单例 + 四类分文件 Extension。
- 强制所有数据表遵守 `TableCodable` 协议 + 统一驼峰命名 + 字段文档路径注释。
- 不解决网络缓存层（交给 `Networks`），不解决对象映射（用 WCDB 自带 `Codable` 绑定）。

## 依赖关系
- **被依赖**：所有需要本地持久化的业务模块。
- **依赖**：`WCDB.swift`（主依赖）、`Foundation`。
- **反向依赖**：禁止业务模块绕过 `DBManager` 直接 `import WCDB`，保证埋点与升级可控。

## 文件结构
| 路径 | 作用 |
|------|------|
| `Database/Classes/DBManager.swift` | 单例入口，持有 `Database` 实例 + 通用建表/删表 |
| `Database/Classes/DBManager+Insert.swift` | 插入 / 批量插入 API |
| `Database/Classes/DBManager+Query.swift` | 查询 API，支持条件 + 排序 + 分页 |
| `Database/Classes/DBManager+Update.swift` | 按主键 / 条件更新 API |
| `Database/Classes/DBManager+Delete.swift` | 按主键 / 条件删除 API |

### 表命名约定
- 表名必须为 `模块名_table`，如 `DApp_table`。
- 字段采用驼峰命名，禁止中文拼音；统一在 `Tables` 目录附字段说明文档（Numbers / Excel）。
- 模型顶部用 `///` 注释指向字段文档路径，方便查阅。

```swift
/// 字段详解见文档：https://github.com/yangKJ/Database/blob/master/Tables/DApp.numbers
public struct DAppDatabase: TableCodable {
    public static let DApp_table = "DApp_table"
    public var ID: Int?
    public var title: String?
}
```

## 使用示例
```swift
// 增
try DBManager.shared.insert(objects: [dapp], intoTable: DAppDatabase.DApp_table)

// 查
let list = try DBManager.shared.query(
    fromTable: DAppDatabase.DApp_table,
    where: DAppDatabase.Properties.ID > 0,
    orderBy: DAppDatabase.Properties.ID.desc(),
    limit: 20
)

// 改
try DBManager.shared.update(
    onTable: DAppDatabase.DApp_table,
    where: DAppDatabase.Properties.ID == dapp.ID,
    object: dapp
)

// 删
try DBManager.shared.delete(
    fromTable: DAppDatabase.DApp_table,
    where: DAppDatabase.Properties.ID == dapp.ID
)
```

## 维护者
<!-- yangKJ -->
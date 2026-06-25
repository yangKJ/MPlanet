//
//  Keychain.swift
//  ProductLib
//
//  Created by Condy on 2025/6/24.
//
//  简单的 Keychain 包装器，替代 UserDefaults 存储敏感数据（如 token、密码等）。
//  使用 Security 框架的 SecItemAdd / SecItemUpdate / SecItemCopyMatching / SecItemDelete API。
//

import Foundation
import Security

public enum KeychainError: Error {
    case unhandled(OSStatus)
    case invalidData
}

/// 通用 Keychain 包装器。
/// - Note: 用法 `Keychain.shared["__hasUserLoggedToken__"] = "xxx"`、`Keychain.shared["key"] as? String`
public final class Keychain {

    public static let shared = Keychain()

    private let service: String

    public init(service: String = Bundle.main.bundleIdentifier ?? "com.mplanet.keychain") {
        self.service = service
    }

    // MARK: - Subscript

    public subscript(key: String) -> Any? {
        get {
            return try? self.getData(key: key) as Any
        }
        set {
            if let value = newValue as? String {
                try? self.set(value: value, key: key)
            } else if let value = newValue as? Data {
                try? self.set(data: value, key: key)
            } else if newValue == nil {
                try? self.remove(key: key)
            }
        }
    }

    // MARK: - String

    public func getString(key: String) throws -> String? {
        guard let data = try getData(key: key) else { return nil }
        return String(data: data, encoding: .utf8)
    }

    public func set(value: String, key: String) throws {
        guard let data = value.data(using: .utf8) else {
            throw KeychainError.invalidData
        }
        try set(data: data, key: key)
    }

    // MARK: - Data

    public func getData(key: String) throws -> Data? {
        let query: [String: Any] = [
            kSecClass as String: kSecClassGenericPassword,
            kSecAttrService as String: service,
            kSecAttrAccount as String: key,
            kSecReturnData as String: true,
            kSecMatchLimit as String: kSecMatchLimitOne,
        ]
        var result: AnyObject?
        let status = SecItemCopyMatching(query as CFDictionary, &result)
        switch status {
        case errSecSuccess:
            return result as? Data
        case errSecItemNotFound:
            return nil
        default:
            throw KeychainError.unhandled(status)
        }
    }

    public func set(data: Data, key: String) throws {
        let query: [String: Any] = [
            kSecClass as String: kSecClassGenericPassword,
            kSecAttrService as String: service,
            kSecAttrAccount as String: key,
        ]
        // 先尝试更新
        let attributes: [String: Any] = [
            kSecValueData as String: data,
            kSecAttrAccessible as String: kSecAttrAccessibleAfterFirstUnlock,
        ]
        let status = SecItemUpdate(query as CFDictionary, attributes as CFDictionary)
        switch status {
        case errSecSuccess:
            return
        case errSecItemNotFound:
            // 不存在则 add
            var newItem = query
            newItem[kSecValueData as String] = data
            newItem[kSecAttrAccessible as String] = kSecAttrAccessibleAfterFirstUnlock
            let addStatus = SecItemAdd(newItem as CFDictionary, nil)
            if addStatus != errSecSuccess {
                throw KeychainError.unhandled(addStatus)
            }
        default:
            throw KeychainError.unhandled(status)
        }
    }

    public func remove(key: String) throws {
        let query: [String: Any] = [
            kSecClass as String: kSecClassGenericPassword,
            kSecAttrService as String: service,
            kSecAttrAccount as String: key,
        ]
        let status = SecItemDelete(query as CFDictionary)
        if status != errSecSuccess && status != errSecItemNotFound {
            throw KeychainError.unhandled(status)
        }
    }
}

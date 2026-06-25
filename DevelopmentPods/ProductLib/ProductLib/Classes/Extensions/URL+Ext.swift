//
//  URL+Ext.swift
//  ProductLib
//
//  Created by Condy on 2024/5/20.
//

import Foundation

extension BoxWrapper where Base == URL {
    
    public var queryParameters: [String: String]? {
        guard let components = URLComponents(url: base, resolvingAgainstBaseURL: false),
              let queryItems = components.queryItems else {
            return nil
        }
        var items: [String: String] = [:]
        for queryItem in queryItems {
            items[queryItem.name] = queryItem.value
        }
        return items
    }
    
    public func appendingQueryParameters(_ parameters: [String: String]) -> URL? {
        // 修复：URLComponents(url:resolvingAgainstBaseURL:) 在 malformed URL 时返回 nil，
        // urlComponents.url 在 components 不合法时也返回 nil
        // 都改为可选链 + 兜底
        guard var urlComponents = URLComponents(url: base, resolvingAgainstBaseURL: true) else {
            return nil
        }
        var items = urlComponents.queryItems ?? []
        items += parameters.map({ URLQueryItem(name: $0, value: $1) })
        urlComponents.queryItems = items
        return urlComponents.url
    }
    
    /// Get extended attribute.
    public func extendedAttribute(forName name: String) throws -> Data {
        /// Helper function to create an NSError from a Unix errno.
        func posixError(_ err: Int32) -> NSError {
            let userInfo = [
                NSLocalizedDescriptionKey: String(cString: strerror(err))
            ]
            return NSError(domain: NSPOSIXErrorDomain, code: Int(err), userInfo: userInfo)
        }
        let data = try base.withUnsafeFileSystemRepresentation { fileSystemPath -> Data in
            // Determine attribute size:
            let length = getxattr(fileSystemPath, name, nil, 0, 0, 0)
            guard length >= 0 else {
                throw posixError(errno)
            }
            // Create buffer with required size:
            var data = Data(count: length)
            // Retrieve attribute:
            let result = data.withUnsafeMutableBytes { [count = data.count] in
                getxattr(fileSystemPath, name, $0.baseAddress, count, 0, 0)
            }
            guard result >= 0 else {
                throw posixError(errno)
            }
            return data
        }
        return data
    }
}

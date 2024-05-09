//
//  URL+Ext.swift
//  ImageX
//
//  Created by Condy on 2023/7/7.
//

import Foundation
import Harbeth

extension URL: ImageXCompatible { }

extension ImageXEngine where URL == Base {
    
    /// Determine if this represents an image file stored in a baked.
    public var isBaked: Bool {
        let bakedImageFileExtensions = Set([
            "jpg", "jpeg", "png", "tiff", "tif", "gif", "heic", "heif"
        ])
        return bakedImageFileExtensions.contains(base.pathExtension.lowercased())
    }
    
    /// Set extended attribute.
    func setExtendedAttribute(data: Data, forName name: String) throws {
        try base.withUnsafeFileSystemRepresentation { fileSystemPath in
            let result = data.withUnsafeBytes {
                setxattr(fileSystemPath, name, $0.baseAddress, data.count, 0, 0)
            }
            guard result >= 0 else {
                throw URL.posixError(errno)
            }
        }
    }
    
    /// Get extended attribute.
    func extendedAttribute(forName name: String) throws -> Data {
        let data = try base.withUnsafeFileSystemRepresentation { fileSystemPath -> Data in
            // Determine attribute size:
            let length = getxattr(fileSystemPath, name, nil, 0, 0, 0)
            guard length >= 0 else {
                throw URL.posixError(errno)
            }
            // Create buffer with required size:
            var data = Data(count: length)
            // Retrieve attribute:
            let result = data.withUnsafeMutableBytes { [count = data.count] in
                getxattr(fileSystemPath, name, $0.baseAddress, count, 0, 0)
            }
            guard result >= 0 else {
                throw URL.posixError(errno)
            }
            return data
        }
        return data
    }
}

extension URL {
    /// Helper function to create an NSError from a Unix errno.
    fileprivate static func posixError(_ err: Int32) -> NSError {
        let userInfo = [
            NSLocalizedDescriptionKey: String(cString: strerror(err))
        ]
        return NSError(domain: NSPOSIXErrorDomain, code: Int(err), userInfo: userInfo)
    }
}

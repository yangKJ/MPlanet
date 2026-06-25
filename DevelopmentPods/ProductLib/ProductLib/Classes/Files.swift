//
//  Files.swift
//  ProductLib
//
//  Created by Condy on 2025/5/20.
//

import Foundation

public struct Files {
    
    private static let totalBytesKey = "totalBytes"
    private let path: String
    
    public init(folder: String = "Common", fileName: String) throws {
        let folderPath = NSHomeDirectory() + "/Documents/ProductLib/" + folder + "/"
        self.path = folderPath + fileName
        guard FileManager.default.fileExists(atPath: folderPath) == false else {
            return
        }
        do {
            try FileManager.default.createDirectory(atPath: folderPath, withIntermediateDirectories: true)
        } catch {
            throw error
        }
    }
    
    public func readData() -> Data? {
        FileManager.default.contents(atPath: path)
    }
    
    public func hasFileExists() -> Bool {
        FileManager.default.fileExists(atPath: path)
    }
    
    public func removeFileItem() throws {
        try FileManager.default.removeItem(atPath: path)
    }
    
    public func fileCurrentBytes() -> Int64 {
        guard hasFileExists() else {
            return 0
        }
        var downloadedBytes: Int64 = 0
        let fileManager = FileManager.default
        if fileManager.fileExists(atPath: path) {
            let fileDict = try? fileManager.attributesOfItem(atPath: path)
            downloadedBytes = fileDict?[.size] as? Int64 ?? 0
        }
        return downloadedBytes
    }
    
    public func totalBytes() -> Int64 {
        var totalBytes: Int64 = 0
        if let sizeData = try? URL(fileURLWithPath: path).fy.extendedAttribute(forName: Files.totalBytesKey) {
            (sizeData as NSData).getBytes(&totalBytes, length: sizeData.count)
        }
        return totalBytes
    }
}

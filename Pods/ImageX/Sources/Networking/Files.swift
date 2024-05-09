//
//  Files.swift
//  ImageX
//
//  Created by Condy on 2023/5/20.
//

import Foundation
import Harbeth

struct Files {
    
    static let totalBytesKey = "totalBytes"
    
    let path: String
    
    init(named: String) throws {
        let folderPath = NSHomeDirectory() + "/Documents/ImageX/Networking/"
        self.path = folderPath + named
        guard FileManager.default.fileExists(atPath: folderPath) == false else {
            return
        }
        do {
            try FileManager.default.createDirectory(atPath: folderPath, withIntermediateDirectories: true)
        } catch {
            throw error
        }
    }
    
    func hasFileExists() -> Bool {
        FileManager.default.fileExists(atPath: path)
    }
    
    func removeFileItem() throws {
        try FileManager.default.removeItem(atPath: path)
    }
    
    func fileCurrentBytes() -> Int64 {
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
    
    func totalBytes() -> Int64 {
        var totalBytes: Int64 = 0
        if let sizeData = try? URL(fileURLWithPath: path).img.extendedAttribute(forName: Files.totalBytesKey) {
            (sizeData as NSData).getBytes(&totalBytes, length: sizeData.count)
        }
        return totalBytes
    }
    
    func readData() -> Data? {
        FileManager.default.contents(atPath: path)
    }
}

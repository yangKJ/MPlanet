//
//  Cached.swift
//  Wintersweet
//
//  Created by Condy on 2023/1/6.
//

import Foundation
import CoreFoundation

public struct Cached {
    
    /// A singleton shared memory cache.
    fileprivate static var memory: NSCache<AnyObject, AnyObject> {
        struct SharedCache {
            static var shared: NSCache<AnyObject, AnyObject> = NSCache()
        }
        return SharedCache.shared
    }
    /// A singleton shared disk cache.
    fileprivate static var disk: FileManager {
        struct SharedCache {
            static var shared: FileManager = FileManager()
        }
        return SharedCache.shared
    }
    
    static var backgroundQueue: DispatchQueue {
        struct SharedCache {
            // 自定义后台运行级别并行队列
            static var shared = DispatchQueue(label: "com.condy.wintersweet.cached.queue", qos: .background, attributes: [.concurrent])
        }
        return SharedCache.shared
    }
    
    public struct Options: OptionSet, Hashable {
        /// Returns a raw value.
        public let rawValue: UInt16
        
        /// Initialializes options with a given raw values.
        public init(rawValue: UInt16) {
            self.rawValue = rawValue
        }
        
        /// Do not use any cache.
        public static let none = Options(rawValue: 1 << 0)
        /// Cache the data in memory.
        public static let memory = Options(rawValue: 1 << 1)
        /// Cache the data in disk, Use ``GZip`` to compress data.
        public static let disk = Options(rawValue: 1 << 2)
        /// Use memory and disk cache at the same time to read memory first.
        public static let all: Options = [.memory, .disk]
    }
    
    /// Disk document path.
    static let diskCacheDoc: String? = {
        let domains = NSSearchPathForDirectoriesInDomains(.cachesDirectory, .userDomainMask, true)
        guard let prefix = domains.first else {
            return nil
        }
        return (prefix as NSString).appendingPathComponent("IkerCached")
    }()
    
    /// The full path of the md5 encrypted file.
    /// - Parameter url: Link.
    /// - Returns: Cache path.
    static func diskCachePath(key: String, crypto: Wintersweet.CryptoType) -> String? {
        guard let docPath = diskCacheDoc else {
            return nil
        }
        let ciphertext = crypto.encryptedString(with: key)
        return (docPath as NSString).appendingPathComponent(ciphertext)
    }
}

extension Cached.Options {
    
    /// The longest time duration in second of the cache being stored in disk.
    /// Default is 1 week ``60 * 60 * 24 * 7 seconds``.
    /// Setting this to a negative value will make the disk cache never expiring.
    public static var maxCachePeriodInSecond: TimeInterval = 60 * 60 * 24 * 7 {
        didSet {
            maxCachePeriodInSecond = max(0, maxCachePeriodInSecond)
        }
    }
    
    /// The largest disk size can be taken for the cache. It is the total allocated size of cached files in bytes. Default is no limit.
    public static var maxDiskCacheSize: UInt = 0
    
    /// The largest cache cost of memory cache. The total cost is pixel count of all cached images in memory.
    /// Default is unlimited. Memory cache will be purged automatically when a memory warning notification is received.
    public static var maxMemoryCost: UInt = 0 {
        didSet {
            Cached.memory.totalCostLimit = Int(maxMemoryCost)
        }
    }
    
    /// Clear the memory cache.
    public static func cleanedUpMemoryCache() {
        Cached.memory.removeAllObjects()
        //Cached.memory.removeObject(forKey: <#T##AnyObject#>)
    }
    
    /// Clear the disk cache.
    /// - Parameter completion: Complete the callback.
    public static func cleanedUpDiskCache(completion: (() -> Void)? = nil) {
        Cached.backgroundQueue.async {
            guard let docPath = Cached.diskCacheDoc else {
                return
            }
            do {
                try Cached.disk.removeItem(atPath: docPath)
                try Cached.disk.createDirectory(atPath: docPath, withIntermediateDirectories: true, attributes: nil)
            } catch { }
            DispatchQueue.main.async { completion?() }
        }
    }
    
    /// Clear the disk data of the expiration time.
    /// - Parameter completion: Complete the callback.
    public static func cleanedUpExpiredDiskCache(completion: @escaping ((_ expiredURLs: [URL]) -> Void)) {
        Cached.backgroundQueue.async {
            Cached.Options.removeExpiredURLsFromDisk(completion: { expiredURLs in
                DispatchQueue.main.async {
                    completion(expiredURLs)
                }
            })
        }
    }
}

extension Cached.Options {
    
    /// Read disk data or memory data.
    /// - Parameters:
    ///   - key: Image or gif network link address.
    ///   - crypto: File name encryption method.
    ///   - zip: Data decompression method.
    /// - Returns: Data.
    public func read(key: String, crypto: Wintersweet.CryptoType, zip: Wintersweet.ZipType) -> Data? {
        func memoryCacheData(key: String) -> Data? {
            return Cached.memory.object(forKey: key as AnyObject) as? Data
        }
        func diskCacheData(key: String) -> Data? {
            if let cachePath = Cached.diskCachePath(key: key, crypto: crypto),
               let data = try? Data(contentsOf: URL(fileURLWithPath: cachePath)) {
                return zip.decompress(data: data)
            }
            return nil
        }
        switch self {
        case .none:
            return nil
        case .memory:
            return memoryCacheData(key: key)
        case .disk:
            return diskCacheData(key: key)
        case .all:
            if let data = memoryCacheData(key: key) {
                return data
            } else {
                return diskCacheData(key: key)
            }
        default:
            return nil
        }
    }
    
    /// Write data asynchronously to disk and memory.
    /// - Parameters:
    ///   - key: Image or gif network link address.
    ///   - value: Data to be written.
    ///   - crypto: File name encryption method.
    ///   - zip: Data compression method.
    public func write(key: String, value: Data, crypto: Wintersweet.CryptoType, zip: Wintersweet.ZipType) {
        func store2Memory(with data: Data, key: String) {
            Cached.memory.setObject(data as NSData, forKey: key as AnyObject, cost: data.count)
        }
        func store2Disk(with data: Data, key: String) {
            if let docPath = Cached.diskCacheDoc, !Cached.disk.fileExists(atPath: docPath) {
                let url = URL(fileURLWithPath: docPath, isDirectory: true)
                try? Cached.disk.createDirectory(at: url, withIntermediateDirectories: true, attributes: nil)
            }
            guard let cachePath = Cached.diskCachePath(key: key, crypto: crypto) else {
                return
            }
            let data = zip.compressed(data: data)
            Cached.disk.createFile(atPath: cachePath, contents: data, attributes: nil)
        }
        Cached.backgroundQueue.async {
            switch self {
            case .none:
                break
            case .memory:
                store2Memory(with: value, key: key)
            case .disk:
                store2Disk(with: value, key: key)
            case .all:
                store2Memory(with: value, key: key)
                store2Disk(with: value, key: key)
            default:
                break
            }
        }
    }
}

extension Cached.Options {
    
    /// Get disk cache files and file sizes and expired files.
    static func getCachedFilesAndExpiredURLs() -> (expiredURLs: [URL], cachedFiles: [URL: URLResourceValues], diskCacheSize: UInt)? {
        guard let docPath = Cached.diskCacheDoc else {
            return nil
        }
        let resourceKeys: Set<URLResourceKey> = [.isDirectoryKey, .contentAccessDateKey, .totalFileAllocatedSizeKey]
        guard let fileUrls = (try? Cached.disk.contentsOfDirectory(at: URL(fileURLWithPath: docPath),
                                                                   includingPropertiesForKeys: Array(resourceKeys),
                                                                   options: .skipsHiddenFiles)) else {
            return nil
        }
        let expiredDate = Date(timeIntervalSinceNow: -Cached.Options.maxCachePeriodInSecond)
        var cachedFiles = [URL: URLResourceValues]()
        var expiredURLs = [URL]()
        var diskCacheSize: UInt = 0
        for fileUrl in fileUrls {
            do {
                let resourceValues = try fileUrl.resourceValues(forKeys: resourceKeys)
                // If it is a Directory. Continue to next file URL.
                if resourceValues.isDirectory == true {
                    continue
                }
                // If this file is expired, add it to URLsToDelete
                if let lastAccessData = resourceValues.contentAccessDate,
                   (lastAccessData as NSDate).laterDate(expiredDate) == expiredDate {
                    expiredURLs.append(fileUrl)
                    continue
                }
                if let fileSize = resourceValues.totalFileAllocatedSize {
                    diskCacheSize += UInt(fileSize)
                    cachedFiles[fileUrl] = resourceValues
                }
            } catch { }
        }
        return (expiredURLs, cachedFiles, diskCacheSize)
    }
    
    /// Remove expired files from disk.
    /// - Parameter completion: Removed file URLs callback.
    static func removeExpiredURLsFromDisk(completion: ((_ expiredURLs: [URL]) -> Void)? = nil) {
        guard let tuple = getCachedFilesAndExpiredURLs() else {
            return
        }
        var expiredURLs = tuple.expiredURLs
        let cachedFiles = tuple.cachedFiles
        var diskCacheSize = tuple.diskCacheSize
        for fileURL in expiredURLs {
            try? Cached.disk.removeItem(at: fileURL)
        }
        typealias Sorted = Dictionary<URL, URLResourceValues>
        // Sort files by last modify date. We want to clean from the oldest files.
        func keysSortedByValue(dict: Sorted, isOrderedBefore: (Sorted.Value, Sorted.Value) -> Bool) -> [Sorted.Key] {
            return Array(dict).sorted{ isOrderedBefore($0.1, $1.1) }.map{ $0.0 }
        }
        if Cached.Options.maxDiskCacheSize > 0 && diskCacheSize > Cached.Options.maxDiskCacheSize {
            let sortedFiles = keysSortedByValue(dict: cachedFiles) { value1, value2 -> Bool in
                if let date1 = value1.contentAccessDate, let date2 = value2.contentAccessDate {
                    return date1.compare(date2) == .orderedAscending
                }
                // Not valid date information. This should not happen. Just in case.
                return true
            }
            let targetSize = Cached.Options.maxDiskCacheSize / 2
            for fileURL in sortedFiles {
                if let _ = try? Cached.disk.removeItem(at: fileURL) {
                    expiredURLs.append(fileURL)
                    if let fileSize = cachedFiles[fileURL]?.totalFileAllocatedSize {
                        diskCacheSize -= UInt(fileSize)
                    }
                }
                if diskCacheSize < targetSize {
                    break
                }
            }
            completion?(expiredURLs)
        }
    }
}

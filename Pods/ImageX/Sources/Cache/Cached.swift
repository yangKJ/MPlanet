//
//  Cached.swift
//  ImageX
//
//  Created by Condy on 2023/1/6.
//

import Foundation
@_exported import CacheX

public struct CachedCodable: Codable { }

/// For the use of caching modules, please refer to CacheX for more information.
/// See: https://github.com/yangKJ/CacheX
public struct Cached {
    
    /// A singleton cache object.
    public static let shared = Cached()
    
    /// Storage container.
    public let storage: CacheX.Storage<CachedCodable>
    
    /// The name of disk storage, this will be used as folder name within directory.
    public var cachedName: String = "ImageXCached" {
        didSet {
            if var disk = storage.caches[Disk.named] as? Disk {
                disk.named = cachedName
                storage.caches.updateValue(disk, forKey: Disk.named)
            }
        }
    }
    
    /// The longest time duration in second of the cache being stored in disk. default is an week.
    public var expiry: Expiry = CacheX.Expiry.week {
        didSet {
            if var disk = storage.caches[Disk.named] as? Disk {
                disk.expiry = expiry
                storage.caches.updateValue(disk, forKey: Disk.named)
            }
        }
    }
    
    /// The largest disk size can be taken for the cache. It is the total allocated size of cached files in bytes. default 20kb.
    public var maxCountLimit: CacheX.Disk.Byte = 20 * 1024 {
        didSet {
            if var disk = storage.caches[Disk.named] as? Disk {
                disk.maxCountLimit = maxCountLimit
                storage.caches.updateValue(disk, forKey: Disk.named)
            }
        }
    }
    
    /// The largest cache cost of memory cache. The total cost is pixel count of all cached images in memory.
    /// Memory cache will be purged automatically when a memory warning notification is received.
    public var maxCostLimit: UInt = 0 {
        didSet {
            if var memory = storage.caches[Memory.named] as? Memory {
                memory.maxCostLimit = maxCostLimit
                storage.caches.updateValue(memory, forKey: Memory.named)
            }
        }
    }
    
    private init() {
        /// Create a unspecified processing thread.
        let background = DispatchQueue(label: "com.condy.ImageX.cached.queue.\(UUID().uuidString)", attributes: [.concurrent])
        var disk = Disk()
        disk.named = cachedName
        disk.expiry = expiry
        disk.maxCountLimit = maxCountLimit
        var memory = Memory()
        memory.maxCostLimit = maxCostLimit
        storage = CacheX.Storage<CachedCodable>.init(queue: background, caches: [
            Disk.named: disk,
            Memory.named: memory,
        ])
    }
    
    /// Clean up the data before the expiration time.
    /// - Parameters:
    ///   - expiry: Expiration time.
    ///   - completion: Clean up and complete the callback.
    public func removeExpiriedURLs(expiry: Expiry, completion: @escaping ((_ expiredURLs: [URL]) -> Void)) {
        storage.backgroundQueue.async {
            guard var disk = storage.caches[Disk.named] as? Disk else {
                return
            }
            let lastExpiry = disk.expiry
            disk.expiry = expiry
            disk.removeExpiredURLsFromDisk(completion: completion)
            disk.expiry = lastExpiry
            storage.caches.updateValue(disk, forKey: Disk.named)
        }
    }
    
    /// Have you cleaned up the disk cache in your spare time?
    private(set) static var cleanedUpDiskCached: Bool = false
    /// Clear the disk data from a week ago in your spare time.
    public static func openRunloopOptimizeTimeRemoveDiskCached() {
        if cleanedUpDiskCached {
            return
        }
        let disk = Cached.shared.storage.caches[Disk.named] as? Disk
        Cached.shared.storage.backgroundQueue.async {
            RunloopOptimize.default.commit { oneself in
                if Cached.cleanedUpDiskCached {
                    oneself.removeAllTasks()
                } else {
                    disk?.removeExpiredURLsFromDisk { _ in
                        Cached.cleanedUpDiskCached = true
                    }
                }
            }
        }
    }
}

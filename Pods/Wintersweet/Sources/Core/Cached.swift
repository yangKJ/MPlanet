//
//  Cached.swift
//  Wintersweet
//
//  Created by Condy on 2023/1/6.
//

import Foundation
import Lemons

public struct Cached {
    
    /// A singleton cache object.
    public static let shared = Cached()
    
    /// Storage container.
    public let storage: Lemons.Storage<CacheModel>
    
    /// The name of disk storage, this will be used as folder name within directory.
    public static var cachedName: String = "WintersweetCached" {
        didSet {
            Cached.shared.storage.disk.named = cachedName
        }
    }
    
    /// The longest time duration in second of the cache being stored in disk. default is an week.
    public static var expiry: Expiry = Lemons.Expiry.week {
        didSet {
            Cached.shared.storage.disk.expiry = expiry
        }
    }
    
    /// The largest disk size can be taken for the cache. It is the total allocated size of cached files in bytes. default 20kb.
    public static var maxCountLimit: Lemons.Disk.Byte = 20 * 1024 {
        didSet {
            Cached.shared.storage.disk.maxCountLimit = maxCountLimit
        }
    }
    
    /// The largest cache cost of memory cache. The total cost is pixel count of all cached images in memory.
    /// Memory cache will be purged automatically when a memory warning notification is received.
    public static var maxCostLimit: UInt = 0 {
        didSet {
            Cached.shared.storage.memory.maxCostLimit = maxCostLimit
        }
    }
    
    private init() {
        /// Create a unified background processing thread.
        let background = DispatchQueue(label: "com.condy.wintersweet.cached.queue", qos: .background, attributes: [.concurrent])
        storage = Lemons.Storage<CacheModel>.init(queue: background)
        storage.disk.named = Cached.cachedName
        storage.disk.expiry = Cached.expiry
        storage.disk.maxCountLimit = Cached.maxCountLimit
        storage.memory.maxCostLimit = Cached.maxCostLimit
    }
    
    /// Clean up the data before the expiration time.
    /// - Parameters:
    ///   - expiry: Expiration time.
    ///   - completion: Clean up and complete the callback.
    public static func removeExpiriedURLs(expiry: Expiry, completion: @escaping ((_ expiredURLs: [URL]) -> Void)) {
        Cached.shared.storage.backgroundQueue.async {
            let lastExpiry = Cached.shared.storage.disk.expiry
            Cached.shared.storage.disk.expiry = expiry
            Cached.shared.storage.disk.removeExpiredURLsFromDisk(completion: completion)
            Cached.shared.storage.disk.expiry = lastExpiry
        }
    }
    
    /// Have you cleaned up the disk cache in your spare time?
    private(set) static var cleanedUpDiskCached: Bool = false
    /// Clear the disk data from a week ago in your spare time.
    public static func openRunloopOptimizeTimeRemoveDiskCached() {
        if Cached.cleanedUpDiskCached {
            return
        }
        Cached.shared.storage.backgroundQueue.async {
            RunloopOptimize.default.commit { oneself in
                if Cached.cleanedUpDiskCached {
                    oneself.removeAllTasks()
                } else {
                    Cached.shared.storage.disk.removeExpiredURLsFromDisk { _ in
                        Cached.cleanedUpDiskCached = true
                    }
                }
            }
        }
    }
}

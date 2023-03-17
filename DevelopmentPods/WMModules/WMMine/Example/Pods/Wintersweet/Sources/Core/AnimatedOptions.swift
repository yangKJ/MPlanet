//
//  AnimatedOptions.swift
//  Wintersweet
//
//  Created by Condy on 2023/2/23.
//

import Foundation
@_exported import Harbeth

public typealias PreparationCallback = (() -> Void)
public typealias AnimatedCallback = ((_ loopDuration: TimeInterval) -> Void)
public typealias FailedCallback = ((_ error: Error?) -> Void)

/// Other parameters related to GIF playback.
/// Represents gif playback creating options used in Wintersweet.
public struct AnimatedOptions {
    
    public static let `default` = AnimatedOptions()
    
    public let preparation: PreparationCallback?
    public let animated: AnimatedCallback?
    
    /// Desired number of loops. Default  is ``forever``.
    public let loop: Wintersweet.Loop
    
    /// 如果遇见设置`original`以外其他模式显示无效`铺满屏幕`的情况，
    /// 请将承载控件``view.contentMode = .scaleAspectFit``
    /// Content mode used for resizing the frames. Default is ``original``.
    public let contentMode: Wintersweet.ContentMode
    
    /// The number of frames to buffer. Default is 50. A high number will result in more memory usage and less CPU load, and vice versa.
    public let bufferCount: Int
    
    /// Weather or not we should cache the URL response. Default is ``all``.
    public let cacheOption: Wintersweet.Cached.Options
    
    /// Placeholder image. default gray picture.
    public let placeholder: Wintersweet.Placeholder
    
    /// Network data cache naming encryption method, Default is ``md5``.
    public let cacheCrypto: Wintersweet.CryptoType
    
    /// Network data compression or decompression method, default ``gzip``.
    /// This operation is done in the subthread.
    public let cacheDataZip: Wintersweet.ZipType
    
    /// 做组件化操作时刻，解决本地GIF或本地图片所处于另外模块从而读不出数据问题。😤
    /// Do the component operation to solve the problem that the local GIF or Image cannot read the data in another module.
    public var moduleName: String {
        get {
            return modularizationName_ ?? "Wintersweet"
        }
    }
    private let modularizationName_: String?
    
    /// Instantiation of GIF configuration parameters.
    /// - Parameters:
    ///   - loop: Desired number of loops. Default  is ``forever``.
    ///   - placeholder: Placeholder information. Default ``none``.
    ///   - contentMode: Content mode used for resizing the frames. Default is ``original``.
    ///   - bufferCount: The number of frames to buffer. Default is 50. A high number will result in more memory usage and less CPU load, and vice versa.
    ///   - cacheOption: Weather or not we should cache the URL response. Default  is ``all``.
    ///   - cacheCrypto: Network data cache naming encryption method, Default is ``md5``.
    ///   - cacheDataZip: Network data compression or decompression method, this operation is done in the subthread. default ``gzip``.
    ///   - moduleName: Do the component operation to solve the problem that the local GIF cannot read the data in another module.
    ///   - preparation: Ready to play time callback.
    ///   - animated: Be played GIF.
    public init(loop: Loop = .forever,
                placeholder: Placeholder = .none,
                contentMode: ContentMode = .original,
                bufferCount: Int = 50,
                cacheOption: Cached.Options = .all,
                cacheCrypto: CryptoType = .md5,
                cacheDataZip: ZipType = .gzip,
                moduleName: String? = nil,
                preparation: PreparationCallback? = nil,
                animated: AnimatedCallback? = nil) {
        self.loop = loop
        self.contentMode = contentMode
        self.bufferCount = bufferCount
        self.cacheOption = cacheOption
        self.cacheCrypto = cacheCrypto
        self.cacheDataZip = cacheDataZip
        self.placeholder = placeholder
        self.preparation = preparation
        self.animated = animated
        self.modularizationName_ = moduleName
        AnimatedOptions.setupRunloopOptimizeCleanedUpDiskCached()
    }
    
    internal var displayed: Bool = false // 防止重复设置占位信息
    internal func setDisplayed(placeholder displayed: Bool) -> Self {
        var options = self
        options.displayed = displayed
        return options
    }
}

extension AnimatedOptions {
    
    /// Have you cleaned up the disk cache in your spare time?
    private(set) static var cleanedUpDiskCached: Bool = false
    /// Configure free time to clear the disk cache.
    static func setupRunloopOptimizeCleanedUpDiskCached() {
        if AnimatedOptions.cleanedUpDiskCached {
            return
        }
        Cached.backgroundQueue.async {
            RunloopOptimize.default.commit { oneself in
                if AnimatedOptions.cleanedUpDiskCached {
                    oneself.removeAllTasks()
                } else {
                    Cached.Options.cleanedUpExpiredDiskCache { _ in
                        AnimatedOptions.cleanedUpDiskCached = true
                    }
                }
            }
        }
    }
}


//extension RunloopOptimize {
//    private func setupNotification() {
//        #if !os(macOS) && !os(watchOS)
//        NotificationCenter.default.addObserver(self,
//                                               selector: #selector(clearMemoryCache),
//                                               name: UIApplication.didReceiveMemoryWarningNotification,
//                                               object: nil)
//        NotificationCenter.default.addObserver(self,
//                                               selector: #selector(backgroundCleanExpiredDiskCache),
//                                               name: UIApplication.didEnterBackgroundNotification,
//                                               object: nil)
//        #endif
//    }
//}
//
//#if !os(macOS) && !os(watchOS)
//extension RunloopOptimize {
//
//    @objc public func clearMemoryCache() {
//        Cached.Options.cleanedUpMemoryCache()
//    }
//
//    @objc public func backgroundCleanExpiredDiskCache() {
//        if cleanuped == true {
//            return
//        }
//        let selector = NSSelectorFromString("sharedApplication")
//        guard UIApplication.responds(to: selector),
//              let application = UIApplication.perform(selector).takeUnretainedValue() as? UIApplication else {
//            return
//        }
//
//        func endBackgroundTask(_ task: inout UIBackgroundTaskIdentifier) {
//            application.endBackgroundTask(task)
//            task = UIBackgroundTaskIdentifier.invalid
//        }
//
//        var backgroundTask: UIBackgroundTaskIdentifier!
//        backgroundTask = application.beginBackgroundTask {
//            endBackgroundTask(&backgroundTask)
//        }
//
//        Cached.Options.cleanedUpExpiredDiskCache(completion: {
//            endBackgroundTask(&backgroundTask)
//        })
//    }
//}
//#endif

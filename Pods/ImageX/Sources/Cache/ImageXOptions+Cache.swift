//
//  ImageXOptions+Cache.swift
//  ImageX
//
//  Created by Condy on 2023/7/12.
//

import Foundation
import CacheX

extension ImageXOptions {
    
    public struct Cache {
        
        /// Weather or not we should cache the URL response. Default is ``diskAndMemory``.
        public var cacheOption: CacheX.CachedOptions = .diskAndMemory
        
        /// Network data cache naming encryption method, Default is ``md5``.
        public var cacheCrypto: CacheX.CryptoType = .md5
        
        /// Network data compression or decompression method, default ``gzip``.
        /// This operation is done in the subthread.
        public var cacheDataZip: ImageX.ZipType = .gzip
        
        public init() { }
    }
}

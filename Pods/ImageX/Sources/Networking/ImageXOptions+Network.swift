//
//  ImageXOptions+Network.swift
//  ImageX
//
//  Created by Condy on 2023/7/12.
//

import Foundation

extension ImageXOptions {
    
    public struct Network {
        
        /// Network max retry count and retry interval, default max retry count is ``3`` and retry ``3s`` interval mechanism.
        public var retry: ImageX.DelayRetry = .max3s
        
        /// Web images or animated images link download priority.
        public var downloadPriority: Float = URLSessionTask.defaultPriority
        
        /// The timeout interval for the request. Defaults to 20.0
        public var timeoutInterval: TimeInterval = 20
        
        /// Network resource data download progress response interval.
        public var downloadInterval: TimeInterval = 0.02
        
        /// Network image download headers.
        public var headers: [String: String] = [:]
        
        /// This data is sent as the message body of the request, as in done in an HTTP POST request.
        public var httpBody: Data?
        
        public init() { }
        
        internal var failed: ((_ error: Error) -> Void)?
        /// Network download task failure information.
        /// - Parameter block: Failed the callback.
        public mutating func setNetworkFailed(block: @escaping ((_ error: Error) -> Void)) {
            self.failed = block
        }
        
        internal var progressBlock: ((_ currentProgress: CGFloat) -> Void)?
        /// Network data task download progress.
        /// - Parameter block: Download the callback.
        public mutating func setNetworkProgress(block: @escaping ((_ currentProgress: CGFloat) -> Void)) {
            self.progressBlock = block
        }
    }
}

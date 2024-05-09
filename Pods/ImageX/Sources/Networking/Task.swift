//
//  DownloadTask.swift
//  ImageX
//
//  Created by Condy on 2023/5/20.
//

import Foundation

public struct Task {
    
    /// The Original URL is encrypted by md5.
    public let key: String
    
    /// Original URL of the image or gif request.
    public let url: URL
    
    /// Download task.
    public let task: URLSessionDataTask
    
    /// Cancel this task if it is running. It will do nothing if this task is not running.
    public func cancel() {
        Networking.shared.removeDownloadURL(with: key)
    }
}

//
//  DataResult.swift
//  ImageX
//
//  Created by Condy on 2023/5/20.
//

import Foundation

public struct DataResult {
    
    public enum DownloadStatus {
        case downloading
        case complete
    }
    
    /// The Original URL is encrypted by md5.
    public let key: String
    
    /// Original URL of the image or gif request.
    public let url: URL?
    
    /// The raw data received from downloader.
    public let data: Data
    
    /// An NSURLResponse object represents a URL load response in a manner independent of protocol and URL scheme.
    public let response: URLResponse?
    
    /// Current resource download status.
    public let downloadStatus: DownloadStatus
}

//
//  Networking.swift
//  ImageX
//
//  Created by Condy on 2023/5/20.
//

import Foundation
import CommonCrypto
import Harbeth

struct Networking {
    
    typealias DownloadResultBlock = ((Result<DataResult, Error>) -> Void)
    typealias DownloadBlocks = (download: DownloadResultBlock, progress: ((CGFloat) -> Void)?)
    
    static let shared = Networking()
    
    private init() { }
    
    @Locked var downloaders = [String: DataDownloader]()
    
    @Locked var cacheCallBlocks = [(key: String, block: DownloadBlocks)]()
    
    /// Add network download data task.
    /// - Parameters:
    ///   - url: The link url.
    ///   - options: Configuration network parameter.
    ///   - downloadBlock: Download callback response.
    /// - Returns: The data task.
    @discardableResult
    func addDownloadURL(_ url: URL, options: ImageXOptions, downloadBlock: @escaping DownloadResultBlock) -> URLSessionDataTask {
        let key = md5Encrypted(with: url.absoluteString)
        self.cacheCallBlocks.append((key, (downloadBlock, options.Network.progressBlock)))
        if let downloader = self.downloaders[key] {
            return downloader.task
        }
        var request = URLRequest(url: url, cachePolicy: .reloadIgnoringLocalCacheData, timeoutInterval: options.Network.timeoutInterval)
        request.httpShouldUsePipelining = true
        if let httpBody = options.Network.httpBody {
            request.httpBody = httpBody
            request.httpMethod = "POST"
        }
        for (field, value) in options.Network.headers {
            request.setValue(value, forHTTPHeaderField: field)
        }
        let retry = options.Network.retry
        let interval = options.Network.downloadInterval
        let downloader = DataDownloader(request: request, named: key, retry: retry, interval: interval) { state, data, response in
            for call in cacheCallBlocks where key == call.key {
                switch state {
                case .downloading(let currentProgress):
                    let rest = DataResult(key: key, url: url, data: data!, response: response, downloadStatus: .downloading)
                    call.block.progress?(currentProgress)
                    call.block.download(.success(rest))
                case .complete:
                    let rest = DataResult(key: key, url: url, data: data!, response: response, downloadStatus: .complete)
                    call.block.progress?(1.0)
                    call.block.download(.success(rest))
                case .failed(let error):
                    call.block.download(.failure(error))
                case .finished(let error):
                    call.block.download(.failure(error))
                }
            }
            switch state {
            case .complete, .finished:
                self.removeDownloadURL(with: key)
            case .failed, .downloading:
                break
            }
        }
        self.downloaders[key] = downloader
        return downloader.task
    }
    
    /// Remove the download data task.
    /// - Parameter url: The link url.
    func removeDownloadURL(with url: URL) {
        let key = md5Encrypted(with: url.absoluteString)
        removeDownloadURL(with: key)
    }
    
    /// No other callbacks waiting, we can clear the task now.
    func removeDownloadURL(with key: String) {
        self.downloaders[key]?.cancelTask()
        self.downloaders.removeValue(forKey: key)
        self.cacheCallBlocks.removeAll { $0.key == key }
    }
    
    private func md5Encrypted(with string: String) -> String {
        let ccharArray = string.cString(using: String.Encoding.utf8)
        var uint8Array = [UInt8](repeating: 0, count: Int(CC_MD5_DIGEST_LENGTH))
        CC_MD5(ccharArray, CC_LONG(ccharArray!.count - 1), &uint8Array)
        return uint8Array.reduce("") { $0 + String(format: "%02X", $1) }
    }
}

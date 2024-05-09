//
//  DataDownloader.swift
//  ImageX
//
//  Created by Condy on 2023/5/20.
//

import Foundation
import Harbeth

final class DataDownloader: NSObject {
    
    enum Disposition {
        case downloading(CGFloat)
        case complete
        case failed(Error)
        case finished(Error)
    }
    
    private(set) var task: URLSessionDataTask!
    private(set) var session: URLSession?
    private(set) var retry: DelayRetry
    private(set) var request: URLRequest
    private(set) var outputStream: OutputStream?
    private(set) var lastDate: Date!
    /// Downloaded raw data of current task.
    private(set) var mutableData: Data!
    /// The downloaded part.
    private(set) var offset: Int64 = 0
    /// Write to the resource file object.
    private(set) var files: Files!
    /// Network resource data download progress response interval.
    private(set) var interval: TimeInterval
    
    typealias DownloadBlock = ((_ state: Disposition, _ data: Data?, _ response: URLResponse?) -> Void)
    let completionHandler: DownloadBlock
    
    init(request: URLRequest, named: String, retry: DelayRetry, interval: TimeInterval, completionHandler: @escaping DownloadBlock) {
        self.retry = retry
        self.completionHandler = completionHandler
        self.request = request
        self.interval = interval
        super.init()
        do {
            self.files = try Files.init(named: named)
        } catch {
            self.result(data: nil, response: nil, state: .finished(error))
            return
        }
        self.session = URLSession(configuration: .default, delegate: self, delegateQueue: nil)
        self.setupDataTask()
    }
    
    deinit {
        session?.invalidateAndCancel()
    }
    
    func setupDataTask() {
        self.reset()
        self.task = session?.dataTask(with: request)
        self.task.resume()
        self.retry.increaseRetryCount()
    }
    
    func cancelTask() {
        self.session?.invalidateAndCancel()
        if self.task.state != .canceling {
            self.task.cancel()
        }
    }
}

extension DataDownloader {
    
    private func reset() {
        self.mutableData = Data()
        self.lastDate = Date()
        self.offset = self.files.fileCurrentBytes()
        if self.offset > 0 {
            if let data = self.files.readData() {
                self.mutableData.append(data)
                let requestRange = String(format: "bytes=%llu-", self.offset)
                self.request.addValue(requestRange, forHTTPHeaderField: "Range")
            } else {
                self.offset = 0
                try? self.files.removeFileItem()
            }
        }
    }
    
    private func result(data: Data?, response: URLResponse?, state: Disposition) {
        switch state {
        case .downloading, .complete:
            if let data = data, data.isEmpty == false {
                self.completionHandler(state, data, response)
            } else {
                self.completionHandler(.failed(invalidDataError()), data, response)
            }
        case .finished:
            self.completionHandler(state, data, response)
        case .failed:
            self.retry.retry(task: task) { [weak self] state_ in
                switch state_ {
                case .retring:
                    self?.setupDataTask()
                case .stop:
                    if let error = self?.maximumFailedError() {
                        self?.completionHandler(.finished(error), data, response)                        
                    }
                }
            }
        }
    }
    
    private func canDownloading() -> Bool {
        let currentDate = Date()
        let time = currentDate.timeIntervalSince(lastDate)
        if time >= self.interval {
            lastDate = currentDate
            return true
        }
        return false
    }
    
    private func hasSuccessCode(_ response: HTTPURLResponse) -> Bool {
        switch response.statusCode {
        case 200 ..< 300:
            return true
        default:
            return false
        }
    }
    
    static let domain = "com.condy.ImageX.downloading"
    private func statusCodeError(_ statusCode: Int) -> NSError {
        let userInfo = [
            NSLocalizedDescriptionKey: HTTPURLResponse.localizedString(forStatusCode: statusCode)
        ]
        return NSError(domain: DataDownloader.domain, code: statusCode, userInfo: userInfo)
    }
    
    private func invalidHTTPURLResponseError() -> NSError {
        let userInfo = [
            NSLocalizedDescriptionKey: "Did receive response is not HTTPURLResponse."
        ]
        return NSError(domain: DataDownloader.domain, code: 2002, userInfo: userInfo)
    }
    
    private func invalidDataError() -> NSError {
        let userInfo = [
            NSLocalizedDescriptionKey: "The downloaded data is empty."
        ]
        return NSError(domain: DataDownloader.domain, code: 3003, userInfo: userInfo)
    }
    
    private func maximumFailedError() -> NSError {
        let userInfo = [
            NSLocalizedDescriptionKey: "The maximum number of failures was reached."
        ]
        return NSError(domain: DataDownloader.domain, code: 4004, userInfo: userInfo)
    }
}

extension DataDownloader: URLSessionDataDelegate {
    
    public func urlSession(_ session: URLSession, 
                           dataTask: URLSessionDataTask,
                           didReceive response: URLResponse,
                           completionHandler: @escaping (URLSession.ResponseDisposition) -> Void) {
        guard let response = response as? HTTPURLResponse else {
            result(data: nil, response: response, state: .failed(invalidHTTPURLResponseError()))
            completionHandler(.cancel)
            return
        }
        guard hasSuccessCode(response) else {
            result(data: nil, response: response, state: .failed(statusCodeError(response.statusCode)))
            completionHandler(.cancel)
            return
        }
        self.outputStream = OutputStream(url: URL(fileURLWithPath: files.path), append: true)
        self.outputStream?.open()
        if offset == 0 {
            var totalBytes = response.expectedContentLength
            let data = Data(bytes: &totalBytes, count: MemoryLayout.size(ofValue: totalBytes))
            do {
                try URL(fileURLWithPath: files.path).img.setExtendedAttribute(data: data, forName: Files.totalBytesKey)
            } catch {
                result(data: nil, response: response, state: .failed(error))
                completionHandler(.cancel)
                return
            }
        }
        completionHandler(.allow)
    }
    
    public func urlSession(_ session: URLSession, dataTask: URLSessionDataTask, didReceive data: Data) {
        guard data.count > 0 else {
            return
        }
        self.mutableData.append(data)
        let dete = Date()
        if dete.timeIntervalSince(lastDate) >= self.interval {
            self.lastDate = dete
            let receiveBytes = dataTask.countOfBytesReceived + offset
            let allBytes = dataTask.response?.expectedContentLength ?? NSURLSessionTransferSizeUnknown
            let currentProgress = min(max(0, CGFloat(receiveBytes) / CGFloat(allBytes)), 1)
            result(data: mutableData, response: dataTask.response, state: .downloading(currentProgress))
        }
        self.outputStream?.write(Array(data), maxLength: data.count)
    }
    
    public func urlSession(_ session: URLSession, task: URLSessionTask, didCompleteWithError error: Error?) {
        self.outputStream?.close()
        guard let response = task.response as? HTTPURLResponse else {
            result(data: nil, response: task.response, state: .failed(invalidHTTPURLResponseError()))
            return
        }
        if let error = error {
            let state: Disposition = self.retry.exceededRetriedCount() ? .finished(error) : .failed(error)
            result(data: nil, response: response, state: state)
        } else if hasSuccessCode(response) {
            result(data: mutableData, response: response, state: .complete)
            self.session?.finishTasksAndInvalidate()
            try? files.removeFileItem()
        } else {
            let error = statusCodeError(response.statusCode)
            let state: Disposition = self.retry.exceededRetriedCount() ? .finished(error) : .failed(error)
            result(data: nil, response: response, state: state)
        }
    }
}

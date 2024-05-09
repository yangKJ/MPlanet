//
//  R.swift
//  ImageX
//
//  Created by Condy on 2023/3/8.
//

import Foundation
import Harbeth

extension Harbeth.R {
    /// Read resource data.
    /// - Parameters:
    ///   - named: File name.
    ///   - withExtension: File format, default is `.gif`
    ///   - forResource: Module where the resource is located.
    /// - Returns: Readed resource data.
    public static func readData(_ named: String, withExtension: String = "gif", forResource: String = "ImageX") -> Data? {
        let bundle: Bundle?
        if let bundlePath = Bundle.main.path(forResource: forResource, ofType: "bundle") {
            bundle = Bundle.init(path: bundlePath)
        } else {
            bundle = Bundle.main
        }
        guard let contentURL = bundle?.url(forResource: named, withExtension: withExtension),
              let data = try? Data(contentsOf: contentURL) else {
            return nil
        }
        return data
    }
    
    /// Read gif data.
    public static func gifData(_ named: String, forResource: String = "ImageX") -> Data? {
        let bundle: Bundle?
        if let bundlePath = Bundle.main.path(forResource: forResource, ofType: "bundle") {
            bundle = Bundle.init(path: bundlePath)
        } else {
            bundle = Bundle.main
        }
        guard let contentURL = ["gif", "GIF", "Gif"].compactMap({
            bundle?.url(forResource: named, withExtension: $0)
        }).first else {
            return nil
        }
        return try? Data(contentsOf: contentURL)
    }
    
    /// Verify that the URL format is correct.
    public static func verifyLink(_ str: String) -> Bool {
        do {
            let dataDetector = try NSDataDetector(types: NSTextCheckingResult.CheckingType.link.rawValue)
            let options = NSRegularExpression.MatchingOptions(rawValue: 0)
            let res = dataDetector.matches(in: str, options: options, range: NSMakeRange(0, str.count))
            if res.count == 1 && res[0].range.location == 0 && res[0].range.length == str.count {
                return true
            }
        } catch { }
        return false
    }
}

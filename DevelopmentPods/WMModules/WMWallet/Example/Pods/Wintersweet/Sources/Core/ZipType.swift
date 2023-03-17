//
//  ZipType.swift
//  Wintersweet
//
//  Created by Condy on 2023/3/9.
//

import Foundation

public enum ZipType {
    /// There is no processing for Data.
    case none
    /// Use GZip to compress or decompress data.
    case gzip
    /// User defined compression and decompression methods.
    case user(compressed: (_ rawData: Data) -> Data, decompress: (_ compressedData: Data) -> Data)
}

extension ZipType {
    
    /// Compress data.
    /// - Parameter data: Waiting for compressed data.
    /// - Returns: Compressed data.
    func compressed(data: Data) -> Data {
        switch self {
        case .none:
            return data
        case .gzip:
            return Queen<GZip>.compress(data: data)
        case .user(let compressed, _):
            return compressed(data)
        }
    }
    
    /// Decompress the compressed data of `ZipType`.
    /// - Parameter data: Data to be decompressed.
    /// - Returns: Decompressed data.
    func decompress(data: Data) -> Data {
        switch self {
        case .none:
            return data
        case .gzip:
            return Queen<GZip>.decompress(data: data) ?? data
        case .user(_, let decompress):
            return decompress(data)
        }
    }
}

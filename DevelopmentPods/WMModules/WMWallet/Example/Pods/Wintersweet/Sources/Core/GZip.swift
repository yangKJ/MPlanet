//
//  GZip.swift
//  Wintersweet
//
//  Created by Condy on 2023/3/2.
//

import Foundation
import zlib
import Harbeth

public struct GZip {
    /// Decompression stream size
    //static let GZIP_STREAM_SIZE: Int32 = Int32(MemoryLayout<z_stream>.size)
    /// Decompression buffer size
    static let GZIP_BUF_LENGTH: Int = 512
}

extension Queen where Base == GZip {
    
    /// Whether to compress data for `GZip`
    public static func isGZipCompressed(_ data: Data) -> Bool {
        return data.starts(with: [0x1f, 0x8b])
    }
    
    /// Compress data by GZip.
    /// - Parameter data: Waiting for compressed data.
    /// - Returns: Compressed data.
    public static func compress(data: Data) -> Data {
        guard data.count > 0 else {
            return data
        }
        var stream = z_stream()
        stream.avail_in = uInt(data.count)
        stream.total_out = 0
        data.withUnsafeBytes { (inputPointer: UnsafeRawBufferPointer) in
            stream.next_in = UnsafeMutablePointer<Bytef>(mutating: inputPointer.bindMemory(to: Bytef.self).baseAddress!)
                .advanced(by: Int(stream.total_in))
        }
        var status = deflateInit2_(&stream,
                                   Z_DEFAULT_COMPRESSION,
                                   Z_DEFLATED,
                                   MAX_WBITS + 16,
                                   MAX_MEM_LEVEL,
                                   Z_DEFAULT_STRATEGY,
                                   ZLIB_VERSION,
                                   Int32(MemoryLayout<z_stream>.size))
        if status != Z_OK {
            return data
        }
        
        var compressedData = Data()
        while stream.avail_out == 0 {
            if Int(stream.total_out) >= compressedData.count {
                compressedData.count += GZip.GZIP_BUF_LENGTH
            }
            stream.avail_out = uInt(GZip.GZIP_BUF_LENGTH)
            compressedData.withUnsafeMutableBytes { (outputPointer: UnsafeMutableRawBufferPointer) in
                stream.next_out = outputPointer.bindMemory(to: Bytef.self).baseAddress!
                    .advanced(by: Int(stream.total_out))
            }
            status = deflate(&stream, Z_FINISH)
            if status != Z_OK && status != Z_STREAM_END {
                return data
            }
        }
        guard deflateEnd(&stream) == Z_OK else {
            return data
        }
        compressedData.count = Int(stream.total_out)
        return compressedData
    }
    
    /// Decompress the compressed data of GZip.
    /// - Parameter data: Data to be decompressed.
    /// - Returns: Decompressed data.
    public static func decompress(data: Data) -> Data? {
        if data.isEmpty { return nil }
        guard isGZipCompressed(data) else {
            return data
        }
        var stream = z_stream()
        data.withUnsafeBytes { (inputPointer: UnsafeRawBufferPointer) in
            stream.next_in = UnsafeMutablePointer<Bytef>(mutating: inputPointer.bindMemory(to: Bytef.self).baseAddress!)
                .advanced(by: Int(stream.total_in))
        }
        stream.avail_in = uInt(data.count)
        stream.total_out = 0
        var status: Int32 = inflateInit2_(&stream, MAX_WBITS + 16, ZLIB_VERSION, Int32(MemoryLayout<z_stream>.size))
        guard status == Z_OK else {
            return nil
        }
        var decompressed = Data(capacity: data.count * 2)
        while stream.avail_out == 0 {
            stream.avail_out = uInt(GZip.GZIP_BUF_LENGTH)
            decompressed.count += GZip.GZIP_BUF_LENGTH
            decompressed.withUnsafeMutableBytes { (outputPointer: UnsafeMutableRawBufferPointer) in
                stream.next_out = outputPointer.bindMemory(to: Bytef.self).baseAddress!
                    .advanced(by: Int(stream.total_out))
            }
            status = inflate(&stream, Z_SYNC_FLUSH)
            if status != Z_OK && status != Z_STREAM_END {
                break
            }
        }
        if inflateEnd(&stream) != Z_OK {
            return nil
        }
        decompressed.count = Int(stream.total_out)
        return decompressed
    }
}

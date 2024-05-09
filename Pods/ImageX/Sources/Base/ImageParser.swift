//
//  ImageParser.swift
//  ImageX
//
//  Created by Condy on 2023/2/28.
//

import Foundation

struct ImageParser {
    
    /// Determines image size of the image based on the given data.
    /// - Parameter data: Data.
    /// - Returns: Image size.
    static func getImageSize(with data: Data) -> CGSize {
        let type = AssetType(data: data)
        var size: CGSize = .zero
        switch type {
        case .jpeg where data.count > 2:
            var size_: CGSize?
            repeat {
                size_ = ImageParser.parse(data, offset: 2, segment: .nextSegment)
            } while size_ == nil
            size = size_ ?? .zero
        case .png where data.count >= 25:
            var size_ = ImageParser.UInt32Size()
            (data as NSData).getBytes(&size_, range: NSRange(location: 16, length: 8))
            size = CGSize(width: Double(CFSwapInt32(size_.width)), height: Double(CFSwapInt32(size_.height)))
        case .gif where data.count >= 11:
            var size_ = ImageParser.UInt16Size()
            (data as NSData).getBytes(&size_, range: NSRange(location: 6, length: 4))
            size = CGSize(width: Double(size_.width), height: Double(size_.height))
        default:
            break
        }
        return size
    }
}

extension ImageParser {
    private enum JPEGHeaderSegment {
        case nextSegment
        case sofSegment
        case skipSegment
        case parseSegment
        case eoiSegment
    }
    
    private struct UInt16Size {
        var width: UInt16 = 0
        var height: UInt16 = 0
    }
    
    private struct UInt32Size {
        var width: UInt32 = 0
        var height: UInt32 = 0
    }
    
    private enum JPEGParseResult {
        case size(CGSize)
        case tuple((data: Data, offset: Int, segment: JPEGHeaderSegment))
    }
    
    private static func parse(_ data: Data, offset: Int, segment: JPEGHeaderSegment) -> CGSize {
        var tuple: JPEGParseResult = .tuple((data, offset: offset, segment: segment))
        while true {
            switch tuple {
            case .size(let size):
                return size
            case .tuple(let newTuple):
                tuple = parse(jpeg: newTuple)
            }
        }
    }
    
    private static func parse(jpeg tuple: (data: Data, offset: Int, segment: JPEGHeaderSegment)) -> JPEGParseResult {
        let data = tuple.data
        let offset = tuple.offset
        let segment = tuple.segment
        if segment == .eoiSegment ||
            (data.count <= offset + 1) ||
            (data.count <= offset + 2) && segment == .skipSegment ||
            (data.count <= offset + 7) && segment == .parseSegment {
            return .size(CGSize.zero)
        }
        switch segment {
        case .nextSegment:
            let newOffset = offset + 1
            var byte = 0x0
            (data as NSData).getBytes(&byte, range: NSRange(location: newOffset, length: 1))
            if byte == 0xFF {
                return .tuple((data, offset: newOffset, segment: .sofSegment))
            } else {
                return .tuple((data, offset: newOffset, segment: .nextSegment))
            }
        case .sofSegment:
            let newOffset = offset + 1
            var byte = 0x0
            (data as NSData).getBytes(&byte, range: NSRange(location: newOffset, length: 1))
            switch byte {
            case 0xE0...0xEF:
                return .tuple((data, offset: newOffset, segment: .skipSegment))
            case 0xC0...0xC3, 0xC5...0xC7, 0xC9...0xCB, 0xCD...0xCF:
                return .tuple((data, offset: newOffset, segment: .parseSegment))
            case 0xFF:
                return .tuple((data, offset: newOffset, segment: .sofSegment))
            case 0xD9:
                return .tuple((data, offset: newOffset, segment: .eoiSegment))
            default:
                return .tuple((data, offset: newOffset, segment: .skipSegment))
            }
        case .skipSegment:
            var length = UInt16(0)
            (data as NSData).getBytes(&length, range: NSRange(location: offset + 1, length: 2))
            let newOffset = offset + Int(CFSwapInt16(length)) - 1
            return .tuple((data, offset: Int(newOffset), segment: .nextSegment))
        case .parseSegment:
            var size = UInt16Size()
            (data as NSData).getBytes(&size, range: NSRange(location: offset + 4, length: 4))
            return .size(CGSize(width: Int(CFSwapInt16(size.width)), height: Int(CFSwapInt16(size.height))))
        default:
            return .size(CGSize.zero)
        }
    }
}

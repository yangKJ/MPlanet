//
//  ExUIImage.swift
//  FeatBox
//
//  Created by Condy on 2020/11/23.
//

import UIKit

extension UIImage {
    
    /// 根据坐标获取图片中的像素颜色值
    public subscript (x: Int, y: Int) -> UIColor? {
        if x < 0 || x > Int(size.width) || y < 0 || y > Int(size.height) {
            return nil
        }
        guard let provider = self.cgImage?.dataProvider, let data = CFDataGetBytePtr(provider.data) else {
            return nil
        }
        let numberOfComponents = 4
        let pixelData = ((Int(size.width) * y) + x) * numberOfComponents
        let r = CGFloat(data[pixelData + 0]) / 255.0
        let g = CGFloat(data[pixelData + 1]) / 255.0
        let b = CGFloat(data[pixelData + 2]) / 255.0
        let a = CGFloat(data[pixelData + 3]) / 255.0
        return UIColor(red: r, green: g, blue: b, alpha: a)
    }
}

extension BoxWrapper where Base: UIImage {
    /// 类似Android中的setColorFilter，可以给图片换颜色。
    /// UI给了一张绿色的图，实际效果却是红色，这时候要么重新换一张红色的图，要么就可以使用这个方法。
    ///
    /// - Parameters:
    ///   - rgbValue: 颜色16进制值
    ///   - alpha: 颜色透明度
    /// - Returns: 滤镜后的图片
    public func setColorFilter(_ rgbValue: Int, _ alpha: CGFloat = 1.0) -> UIImage? {
        return setColorFilter(UIColor(rgb: rgbValue, alpha: alpha))
    }
    
    public func setColorFilter(_ fillColor: UIColor) -> UIImage? {
        guard let cgImage = base.cgImage else { return nil }
        UIGraphicsBeginImageContextWithOptions(base.size, false, base.scale)
        let ctx = UIGraphicsGetCurrentContext()
        ctx?.scaleBy(x: 1, y: -1)
        ctx?.translateBy(x: 0, y: -base.size.height)
        ctx?.draw(cgImage, in: CGRect(origin: .zero, size: base.size))
        ctx?.setBlendMode(.sourceAtop)
        ctx?.setFillColor(fillColor.cgColor)
        ctx?.fill(CGRect(origin: .zero, size: base.size))
        let image = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        return image
    }
    
    /// 裁剪透明区域
    /// - Parameter retainPixel: 保留周边像素
    public func cropAlpha(retainPixel: Int = 0) -> UIImage {
        guard let cgImage = base.cgImage else {
            return base
        }
        let width = cgImage.width
        let height = cgImage.height
        let colorSpace = CGColorSpaceCreateDeviceRGB()
        let bytesPerPixel: Int = 4
        let bytesPerRow = bytesPerPixel * width
        let bitsPerComponent = 8
        let bitmapInfo: UInt32 = CGImageAlphaInfo.premultipliedLast.rawValue | CGBitmapInfo.byteOrder32Big.rawValue
        let context = CGContext(data: nil,
                                width: width,
                                height: height,
                                bitsPerComponent: bitsPerComponent,
                                bytesPerRow: bytesPerRow,
                                space: colorSpace,
                                bitmapInfo: bitmapInfo)
        guard let ptr = context?.data?.assumingMemoryBound(to: UInt8.self) else {
            return base
        }
        
        context?.draw(cgImage, in: CGRect(x: 0, y: 0, width: width, height: height))
        
        var minX = width
        var minY = height
        var maxX: Int = 0
        var maxY: Int = 0
        for x in 1 ..< width {
            for y in 1 ..< height {
                let i = bytesPerRow * Int(y) + bytesPerPixel * Int(x)
                if CGFloat(ptr[i + 3]) / 255.0 > 0 {
                    if (x < minX) { minX = x };
                    if (x > maxX) { maxX = x };
                    if (y < minY) { minY = y };
                    if (y > maxY) { maxY = y };
                }
            }
        }
        let x = max(minX - retainPixel, 0)
        let y = max(minY - retainPixel, 0)
        let w = min(maxX - minX + retainPixel * 2, width)
        let h = min(maxY - minY + retainPixel * 2, height)
        let rect = CGRect(x: x, y: y, width: w, height: h)
        guard let croppedImage = cgImage.cropping(to: rect) else {
            return base
        }
        let ret = UIImage(cgImage: croppedImage, scale: base.scale, orientation: base.imageOrientation)
        return ret
    }
}

// MARK: - edit image
extension BoxWrapper where Base: UIImage {
    /// 将图片裁剪成指定比例（多余部分自动删除）
    /// - Parameter ratio: 裁剪比例
    /// - Returns: 裁剪过后的图片
    public func crop(ratio: CGFloat) -> UIImage {
        let newSize: CGSize
        if base.size.width / base.size.height > ratio {
            newSize = CGSize(width: base.size.height * ratio, height: base.size.height)
        } else {
            newSize = CGSize(width: base.size.width, height: base.size.width / ratio)
        }
        UIGraphicsBeginImageContext(newSize)
        base.draw(in: CGRect(x: (newSize.width - base.size.width ) / 2.0,
                             y: (newSize.height - base.size.height ) / 2.0,
                             width: base.size.width,
                             height: base.size.height))
        let scaledImage = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        return scaledImage ?? base
    }
    
    /// 将图片缩放成指定尺寸（多余部分自动删除）
    /// - Parameter newSize: 裁剪尺寸
    /// - Returns: 裁剪过后的图片
    public func scaled(to newSize: CGSize) -> UIImage {
        let aspectWidth = newSize.width / base.size.width
        let aspectHeight = newSize.height / base.size.height
        let aspectRatio = max(aspectWidth, aspectHeight)
        UIGraphicsBeginImageContext(newSize)
        base.draw(in: CGRect(x: (newSize.width - base.size.width * aspectRatio) / 2.0,
                             y: (newSize.height - base.size.height * aspectRatio) / 2.0,
                             width: base.size.width * aspectRatio,
                             height: base.size.height * aspectRatio))
        let scaledImage = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        return scaledImage ?? base
    }
    
    /// 拉升图片
    /// - Parameter edges: 指定区域进行拉伸
    /// - Returns: 拉升过后的图像
    public func stretchImage(edges: UIEdgeInsets) -> UIImage {
        base.resizableImage(withCapInsets: edges, resizingMode: .stretch)
    }
    
    /// 生成圆形图片
    public func toCircleImage() -> UIImage {
        let shotest = min(base.size.width, base.size.height)
        let outputRect = CGRect(x: 0, y: 0, width: shotest, height: shotest)
        UIGraphicsBeginImageContextWithOptions(outputRect.size, false, 0)
        let context = UIGraphicsGetCurrentContext()
        context?.addEllipse(in: outputRect)
        context?.clip()
        base.draw(in: CGRect(x: (shotest - base.size.width) / 2,
                             y: (shotest - base.size.height) / 2,
                             width: base.size.width,
                             height: base.size.height))
        let maskedImage = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        return maskedImage ?? base
    }
    
    public var revolve180: UIImage {
        guard let cgImage = base.cgImage else {
            return base
        }
        return UIImage(cgImage: cgImage, scale: base.scale, orientation: .down)
    }
}

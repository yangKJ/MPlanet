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
        guard let provider = self.cgImage?.dataProvider,
              let data = CFDataGetBytePtr(provider.data) else {
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
    
    /// 白色背景透明化，色值在[222...255]之间均可祛除
    /// The white background is transparent, and the color value can be removed between [222...255].
    public func imageByMakingWhiteBackgroundTransparent() -> UIImage? {
        // RGB color range to mask (make transparent) R-Low, R-High, G-Low, G-High, B-Low, B-High
        let colorMasking: [CGFloat] = [222, 255, 222, 255, 222, 255]
        return transparentColor(colorMasking: colorMasking)
    }
    
    /// 黑色背景透明化，色值在[0...32]之间均可祛除
    public func imageByRemoveBlackBg() -> UIImage? {
        let colorMasking: [CGFloat] = [0, 32, 0, 32, 0, 32]
        return transparentColor(colorMasking: colorMasking)
    }
    
    /// Transparent background.
    /// - Parameter colorMasking: RGB color range to mask [R-Low, R-High, G-Low, G-High, B-Low, B-High]
    /// - Returns: Remove the picture of the background.
    public func transparentColor(colorMasking: [CGFloat]) -> UIImage? {
        guard let data = base.jpegData(compressionQuality: 1.0), let image = UIImage(data: data) else {
            return nil
        }
        UIGraphicsBeginImageContext(image.size)
        guard let maskedImageRef = image.cgImage?.copy(maskingColorComponents: colorMasking) else {
            return nil
        }
        let rect = CGRect(x: 0, y: 0, width: image.size.width, height: image.size.height)
        UIGraphicsGetCurrentContext()?.translateBy(x: 0.0, y: image.size.height)
        UIGraphicsGetCurrentContext()?.scaleBy(x: 1.0, y: -1.0)
        UIGraphicsGetCurrentContext()?.draw(maskedImageRef, in: rect)
        let result = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        return result
    }
    
    public func rotation() -> UIImage {
        guard let maskedImageRef = base.cgImage else {
            return base
        }
        let rect = CGRectMake(0, 0, base.size.width , base.size.height)
        UIGraphicsBeginImageContextWithOptions(rect.size, false, base.scale)
        let currentContext = UIGraphicsGetCurrentContext()
        currentContext?.clip(to: rect)
        currentContext?.rotate(by: (CGFloat.pi / 2))
        currentContext?.translateBy(x: -rect.size.width, y: -rect.size.height);
        currentContext?.draw(maskedImageRef, in: rect)
        let drawImage = UIGraphicsGetImageFromCurrentImageContext()
        guard let drawCGImage = drawImage?.cgImage else {
            return base
        }
        return UIImage(cgImage: drawCGImage, scale: base.scale, orientation: base.imageOrientation)
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
}

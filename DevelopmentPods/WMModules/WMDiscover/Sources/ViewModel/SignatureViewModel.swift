//
//  SignatureViewModel.swift
//  WMDiscover
//
//  Created by Condy on 2023/5/20.
//

import Foundation
import FeatBox

class SignatureViewModel: BaseViewModel {
    
    /// 截图并转换成签名信息
    func screenshotAndTransformUserSignInfo(signatureView: AVSignatureView) -> Observable<String?> {
        Observable.of(signatureView)
            .flatMapLatest(screenshotAndMatting(_:))
            .map { $0?.pngData()?.base64EncodedString() }
            .flatMapLatest(userSignInfo(base64:))
    }
}

extension SignatureViewModel {
    
    // 截图扣除字体以外部分
    private func screenshotAndMatting(_ signatureView: AVSignatureView) -> Observable<UIImage?> {
        guard let image = signatureView.saveSignToImage(),
              let img = image.ai.imageByMakingWhiteBackgroundTransparent(),
              let cgImage = img.cgImage else {
            return Observable.of(nil)
        }
        let rotatedImage = UIImage.init(cgImage: cgImage, scale: image.scale, orientation: .left)
        return Observable.of(rotatedImage)
    }
    
    // 获取签名信息
    private func userSignInfo(base64: String?) -> Observable<String?> {
        return Observable.of(base64)
    }
}

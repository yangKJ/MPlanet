//
//  BaseImageView.swift
//  FeatBox
//
//  Created by Condy on 2023/10/11.
//

import Foundation

open class BaseImageView: UIImageView {
    
    public override init(frame: CGRect) {
        super.init(frame: frame)
        self.setupInit()
    }
    
    public override init(image: UIImage?) {
        super.init(image: image)
        self.setupInit()
    }
    
    public override init(image: UIImage?, highlightedImage: UIImage?) {
        super.init(image: image, highlightedImage: highlightedImage)
        self.setupInit()
    }
    
    public required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
        self.setupInit()
    }
    
    private func setupInit() {
        layer.masksToBounds = true
        //contentMode = .scaleAspectFit
    }
}

//
//  XCProgressView.swift
//  FeatBox
//
//  Created by Condy on 2022/4/25.
//

import Foundation
import SnapKit
import Extensions

/// 进度控件
open class XCProgressView: UIView {
    
    private lazy var backgroundView = UIView()
    private lazy var progressView = UIView()
    private lazy var progressPoint = UIView()
    
    public var radius: CGFloat = 0 {
        didSet {
            backgroundView.layer.cornerRadius = radius
            backgroundView.layer.masksToBounds = true
            backgroundView.layer.shouldRasterize = true
            backgroundView.layer.rasterizationScale = UIScreen.main.scale
            progressView.layer.cornerRadius = radius
            progressView.layer.masksToBounds = true
            progressView.layer.shouldRasterize = true
            progressView.layer.rasterizationScale = UIScreen.main.scale
        }
    }
    
    public var progress: CGFloat = 0 {
        didSet {
            progressView.snp.remakeConstraints { (make) in
                make.left.top.bottom.equalToSuperview()
                make.width.equalTo(backgroundView.snp.width).multipliedBy(min(1, max(0, progress)))
            }
        }
    }
    
    public func setProgress(_ progress: CGFloat, animated: Bool) {
        if animated {
            UIView.animate(withDuration: 0.35) {
                self.progress = progress
                self.layoutIfNeeded()
            }
        } else {
            self.progress = progress
        }
    }
    
    public var backgroundViewColor: UIColor = UIColor(hex: "EEEEEE") {
        didSet {
            backgroundView.backgroundColor = backgroundViewColor
        }
    }
    
    public var progressColor: UIColor = UIColor.blue {
        didSet {
            progressView.backgroundColor = progressColor
            progressPoint.backgroundColor = progressColor
        }
    }
    
    public var showProgressPoint = false {
        didSet {
            progressPoint.isHidden = !showProgressPoint
        }
    }
    
    public override init(frame: CGRect) {
        super.init(frame: frame)
        setup()
    }
    
    public required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        setup()
    }
    
    private func setup() {
        backgroundView.backgroundColor = backgroundViewColor
        progressView.backgroundColor = progressColor
        progressPoint.backgroundColor = progressColor
        addSubview(backgroundView)
        addSubview(progressView)
        backgroundView.snp.makeConstraints { (make) in
            make.left.right.top.bottom.equalToSuperview()
            make.height.equalTo(2).priority(.high)
        }
        
        addSubview(progressView)
        progressView.snp.makeConstraints { (make) in
            make.left.top.bottom.equalToSuperview()
            make.width.equalTo(backgroundView.snp.width).multipliedBy(min(1, max(0, progress)))
        }
        
        addSubview(progressPoint)
        progressPoint.snp.makeConstraints { (make) in
            make.centerY.equalToSuperview()
            make.centerX.equalTo(progressView.snp.right)
            make.width.height.equalTo(6)
        }
        progressPoint.layer.cornerRadius = 3
        progressPoint.layer.masksToBounds = true
        progressPoint.layer.shouldRasterize = true
        progressPoint.layer.rasterizationScale = UIScreen.main.scale
        progressPoint.layer.borderColor = UIColor.white.cgColor
        progressPoint.layer.borderWidth = 1
        progressPoint.isHidden = !showProgressPoint
    }
}

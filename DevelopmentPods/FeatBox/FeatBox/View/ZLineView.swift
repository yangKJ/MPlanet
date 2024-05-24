//
//  ZLineView.swift
//  FeatBox
//
//  Created by Condy on 2024/5/10.
//

import Foundation
import SnapKit
import ProductLib

public final class ZLineView: UIView {
    
    private var asix: NSLayoutConstraint.Axis = .horizontal
    private var thickness: CGFloat = CGFloat.fy.px1
    
    public convenience init(asix: NSLayoutConstraint.Axis = .horizontal, thickness: CGFloat = CGFloat.fy.px1) {
        self.init()
        self.asix = asix
        self.thickness = thickness
    }
    
    private override init(frame: CGRect) {
        super.init(frame: frame)
        self.backgroundColor = UIColor.fy.line
    }
    
    internal required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        self.backgroundColor = UIColor.fy.line
    }
    
    public override func didMoveToSuperview() {
        self.snp.makeConstraints { (make) in
            if self.asix == .horizontal {
                make.height.equalTo(self.thickness)
            } else {
                make.width.equalTo(self.thickness)
            }
        }
    }
}

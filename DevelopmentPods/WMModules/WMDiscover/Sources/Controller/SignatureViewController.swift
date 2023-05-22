//
//  SignatureViewController.swift
//  WMDiscover
//
//  Created by Condy on 2023/5/16.
//

import Foundation
import FeatBox

class SignatureViewController: BaseViewController {
     
    lazy var signatureView: SignatureView = {
        let view = SignatureView.init()
        view.transform = CGAffineTransform(rotationAngle: CGFloat.pi / 2)
        view.backgroundColor = UIColor.green
        return view
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.setupUI()
    }
    
    var topConstraint: Constraint?
    var bottomConstraint: Constraint?
    var leftConstraint: Constraint?
    var rightConstraint: Constraint?
    var widthConstraint: Constraint?
    var heightConstraint: Constraint?
    
    func setupUI() {
        self.view.addSubview(signatureView)
        
        self.signatureView.snp.makeConstraints { make in
            self.leftConstraint = make.left.equalToSuperview().offset(30).constraint
            self.rightConstraint = make.right.equalToSuperview().inset(30).constraint
            self.topConstraint = make.top.equalToSuperview().offset(40).constraint
            self.bottomConstraint = make.bottom.equalToSuperview().offset(-75).constraint
            self.widthConstraint = make.width.equalToSuperview().constraint
        }
        
        self.topConstraint?.update(offset: -100)
        self.bottomConstraint?.update(offset: 0)
        self.leftConstraint?.update(offset: -100)
        self.rightConstraint?.update(offset: -100)
        self.view.layoutIfNeeded()
    }
}

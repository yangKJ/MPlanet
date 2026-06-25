//
//  BaseButton.swift
//  FeatBox
//
//  Created by Condy on 2023/5/20.
//

import Foundation

/// 所有按钮都需走该实例，方便后续做统一修改
open class BaseButton: UIButton, Storyboardable {

    public override init(frame: CGRect) {
        super.init(frame: frame)
        self.setupInit()
    }

    public required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
        self.setupInit()
    }

    open override func layoutSubviews() {
        super.layoutSubviews()

    }

    private func setupInit() {
        self.titleLabel?.lineBreakMode = .byWordWrapping
    }
}

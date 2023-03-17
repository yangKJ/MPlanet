//
//  ViewController.swift
//  WMDiscover_Example
//
//  Created by Condy on 2023/03/17.
//  Copyright (c) 2023 Condy. All rights reserved.
//

import UIKit

class ViewController: UIViewController {
    
    lazy var label: UILabel = {
        let label = UILabel.init()
        label.frame = CGRect(x: 0, y: 0, width: 100, height: 100)
        label.center = self.view.center
        label.text = "WMDiscover 组件"
        label.textAlignment = .center
        label.font = UIFont.systemFont(ofSize: 16)
        label.textColor = UIColor.green
        label.backgroundColor = UIColor.green.withAlphaComponent(0.3)
        return label
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        self.setupUI()
    }
    
    func setupUI() {
        self.view.addSubview(self.label)
    }
}


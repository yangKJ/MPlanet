//
//  FSCalenderViewController.swift
//  FeatBox
//
//  Created by Condy on 2023/9/28.
//

import Foundation
import Booming

/// 日历窗口
public class FSCalenderViewController<Cell: FSCalendarViewCellable>: Booming.LevelStatusBarWindowController {
    private let calenderHeight: CGFloat
    private let titleLabelHeight: CGFloat
    
    public init(calenderHeight: CGFloat, titleLabelHeight: CGFloat = 64.0) {
        self.calenderHeight = calenderHeight
        self.titleLabelHeight = titleLabelHeight
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    public var maxDate: Date? {
        didSet {
            (showUpView as? FSCalenderView<Cell>)?.maxDate = maxDate ?? Date()
        }
    }
    
    public var minDate: Date? {
        didSet {
            (showUpView as? FSCalenderView<Cell>)?.minDate = minDate ?? Date()
        }
    }
    
    public var titleLabelText: String? {
        didSet {
            (showUpView as? FSCalenderView<Cell>)?.titleLabel.text = titleLabelText
        }
    }
    
    public override func initShowUpViewIfNeed() {
        let y = UIScreen.main.bounds.size.height
        let rect = CGRect(origin: .init(x: 0, y: y), size: UIScreen.main.bounds.size)
        let calender = FSCalenderView<Cell>.init(frame: rect, calenderHeight: calenderHeight, titleLabelHeight: titleLabelHeight)
        self.showUpView = calender
    }
    
    public func request(block: @escaping FSCalenderView<Cell>.RequestCallblock) {
        (self.showUpView as? FSCalenderView<Cell>)?.request(block: block)
    }
}

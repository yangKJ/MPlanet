//
//  FSCalendarViewController.swift
//  FeatBox
//
//  Created by Condy on 2023/9/28.
//

import Foundation
import Booming

/// 日历窗口
public class FSCalendarViewController<Cell: FSCalendarViewCellable>: LevelStatusBarWindowController, Storyboardable {
    private let calendarHeight: CGFloat
    private let titleLabelHeight: CGFloat

    public init(calendarHeight: CGFloat, titleLabelHeight: CGFloat = 64.0) {
        self.calendarHeight = calendarHeight
        self.titleLabelHeight = titleLabelHeight
        super.init(nibName: nil, bundle: nil)
    }

    public required init?(coder: NSCoder) {
        self.calendarHeight = 0
        self.titleLabelHeight = 0
        super.init(coder: coder)
        StoryboardableFatal.notImplemented(coder: coder)
    }

    public var maxDate: Date? {
        didSet {
            contentView?.maxDate = maxDate ?? Date()
        }
    }
    
    public var minDate: Date? {
        didSet {
            contentView?.minDate = minDate ?? Date()
        }
    }
    
    public var titleLabelText: String? {
        didSet {
            contentView?.titleLabel.text = titleLabelText
        }
    }
    
    public override func initShowUpViewIfNeed() {
        let y = UIScreen.main.bounds.size.height
        let rect = CGRect(origin: .init(x: 0, y: y), size: UIScreen.main.bounds.size)
        let calender = FSCalendarView<Cell>.init(frame: rect, calendarHeight: calendarHeight, titleLabelHeight: titleLabelHeight)
        self.showUpView = calender
    }
    
    public func request(block: @escaping FSCalendarView<Cell>.RequestCallblock) {
        contentView?.request(block: block)
    }
    
    private var contentView: FSCalendarView<Cell>? {
        self.showUpView as? FSCalendarView<Cell>
    }
}

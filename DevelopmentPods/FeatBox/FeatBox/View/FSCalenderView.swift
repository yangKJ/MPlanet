//
//  FSCalenderView.swift
//  FeatBox
//
//  Created by Condy on 2023/9/28.
//

import Foundation
import FSCalendar
import SnapKit
import Booming
import ProductLib

public typealias FSCalendarViewCellable = FSCalendarCell & CalendarCellDatasourceable

public protocol CalendarCellDatasourceable {
    associatedtype Element
    /// 设置模型数据
    func setupDatasource(_ datasource: Element?)
}

/// 日历控件
public class FSCalenderView<Cell: FSCalendarViewCellable>: UIView, FSCalendarDataSource, FSCalendarDelegate {
    
    private let calenderHeight: CGFloat
    private let titleLabelHeight: CGFloat
    private var cacheDates: [Date] = []
    private var days: [String: Cell.Element] = [:]
    
    public var minDate: Date = Date()
    
    public var maxDate: Date = Date()
    
    public lazy var gregorian = Date.fy.localCalender//Calendar(identifier: .gregorian)
    
    public lazy var formatter: DateFormatter = {
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd"
        return formatter
    }()
    
    public lazy var titleLabel: UILabel = {
        let label = BaseLabel.init()
        label.frame = CGRect(x: 0, y: 0, width: self.frame.size.width, height: titleLabelHeight)
        label.backgroundColor = UIColor.white
        label.font = UIFont.systemFont(ofSize: 18)
        label.textColor = UIColor.init(hex: "#333333")
        label.textAlignment = .center
        let corners: UIRectCorner = [.topLeft, .topRight]
        let maskPath = UIBezierPath(roundedRect: label.bounds, byRoundingCorners: corners, cornerRadii: CGSize(width: 10, height: 10))
        let maskLayer = CAShapeLayer()
        maskLayer.frame = label.bounds
        maskLayer.path = maskPath.cgPath
        label.layer.mask = maskLayer
        return label
    }()
    
    public lazy var nextButton: UIButton = {
        var button = BaseButton.init(type: .custom)
        button.setImage(Res.image("calendar_month"), for: .normal)
        button.setImage(Res.image("calendar_month_disabled").fy.revolve180, for: .disabled)
        button.fy.touchAreaInsets = UIEdgeInsets(top: 10, left: 10, bottom: 10, right: 10)
        button.addTarget(self, action: #selector(nextButtonAction(_:)), for: .touchUpInside)
        return button
    }()
    
    public lazy var previousButton: UIButton = {
        var button = BaseButton.init(type: .custom)
        button.setImage(Res.image("calendar_month").fy.revolve180, for: .normal)
        button.setImage(Res.image("calendar_month_disabled"), for: .disabled)
        button.fy.touchAreaInsets = UIEdgeInsets(top: 10, left: 10, bottom: 10, right: 10)
        button.addTarget(self, action: #selector(previousButtonAction(_:)), for: .touchUpInside)
        return button
    }()
    
    public lazy var calender: FSCalendar = {
        let calendar = FSCalendar(frame: CGRect(x: 0, y: titleLabelHeight, width: self.frame.size.width, height: calenderHeight))
        calendar.backgroundColor = UIColor.white
        calendar.accessibilityIdentifier = "calendar"
        calendar.dataSource = self
        calendar.delegate = self
        calendar.scrollDirection = .horizontal
        calendar.pagingEnabled = true
        calendar.allowsMultipleSelection = false
        calendar.rowHeight = 60
        calendar.placeholderType = .none
        calendar.locale = Locale(identifier: "zh-Hans-CN")
        calendar.weekdayHeight = 24
        calendar.headerHeight = 40
        calendar.scope = .month
        calendar.adjustsBoundingRectWhenChangingMonths = true
        calendar.firstWeekday = 1
        
        calendar.appearance.headerMinimumDissolvedAlpha = 0.0
        calendar.appearance.eventSelectionColor = UIColor.clear
        calendar.appearance.eventOffset = CGPoint(x: 0, y: 0)
        calendar.appearance.eventDefaultColor = UIColor.clear
        calendar.appearance.headerTitleColor = UIColor.init(hex: "333333")
        calendar.appearance.headerTitleFont = UIFont.systemFont(ofSize: 18)
        calendar.appearance.headerDateFormat = "yyyy年MM月"
        calendar.appearance.weekdayTextColor = UIColor.init(hex: "#000000").withAlphaComponent(0.45)
        calendar.appearance.selectionColor = UIColor.init(hex: "#000000").withAlphaComponent(0.45)
        calendar.appearance.todayColor = UIColor.red
        calendar.appearance.borderRadius = 1.0
        calendar.appearance.caseOptions = [.headerUsesUpperCase, .weekdayUsesSingleUpperCase]
        calendar.appearance.separators = .none
        calendar.appearance.headerTitleOffset = CGPoint(x: 0, y: 0)
        calendar.appearance.titleOffset = CGPoint(x: 0, y: -5)
        calendar.appearance.headerSeparatorColor = UIColor.clear
        
        calendar.calendarHeaderView.backgroundColor = UIColor.white
        calendar.calendarWeekdayView.backgroundColor = UIColor.clear
        
        calendar.today = nil // Hide the today circle
        calendar.register(Cell.self, forCellReuseIdentifier: "CalenderCell")
        calendar.clipsToBounds = true // Remove top/bottom line
        
        calendar.swipeToChooseGesture.isEnabled = true // Swipe-To-Choose
        
        return calendar
    }()
    
    public init(frame: CGRect, calenderHeight: CGFloat, titleLabelHeight: CGFloat) {
        self.calenderHeight = calenderHeight
        self.titleLabelHeight = titleLabelHeight
        super.init(frame: frame)
        self.setupUI()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    @objc func previousButtonAction(_ sender: UIButton) {
        let date = self.calender.currentPage.fy.monthAgo(with: 1)
        if date >= minDate {
            self.calender.setCurrentPage(date, animated: true)
            self.request()
        }
        self.setupButtonIconDisabled()
    }
    
    @objc func nextButtonAction(_ sender: UIButton) {
        let date = self.calender.currentPage.fy.monthLater(with: 1)
        if date <= maxDate {
            self.calender.setCurrentPage(date, animated: true)
            self.request()
        }
        self.setupButtonIconDisabled()
    }
    
    // MARK: - public methods
    
    public typealias RequestCallblock = ((_ date: Date, _ block: @escaping ([String: Cell.Element]) -> Void) -> Void)
    
    private var requestBlock: RequestCallblock?
    
    public func request(block: @escaping RequestCallblock) {
        self.requestBlock = block
        self.request()
    }
    
    // MARK: - FSCalendarDataSource
    
    public func calendar(_ calendar: FSCalendar, numberOfEventsFor date: Date) -> Int {
        return 1
    }
    
    public func minimumDate(for calendar: FSCalendar) -> Date {
        minDate
    }
    
    public func maximumDate(for calendar: FSCalendar) -> Date {
        maxDate
    }
    
    public func calendar(_ calendar: FSCalendar, cellFor date: Date, at position: FSCalendarMonthPosition) -> FSCalendarCell {
        calendar.dequeueReusableCell(withIdentifier: "CalenderCell", for: date, at: position)
    }
    
    public func calendar(_ calendar: FSCalendar, willDisplay cell: FSCalendarCell, for date: Date, at position: FSCalendarMonthPosition) {
        guard let cell = cell as? Cell else {
            return
        }
        let key = date.fy.format(with: .yyyy_mm_dd)
        cell.setupDatasource(self.days[key])
    }
    
    public func calendar(_ calendar: FSCalendar, titleFor date: Date) -> String? {
        if self.gregorian.isDateInToday(date) {
            return "今"
        }
        return nil
    }
    
    // MARK: - FSCalendarDelegate
    
    public func calendarCurrentPageDidChange(_ calendar: FSCalendar) {
        self.request()
        self.setupButtonIconDisabled()
    }
    
    public func calendar(_ calendar: FSCalendar, boundingRectWillChange bounds: CGRect, animated: Bool) {
        //let height = CGRectGetHeight(bounds)
        //print("----\(height)")
    }
}

extension FSCalenderView {
    
    private func setupUI() {
        self.addSubview(self.titleLabel)
        self.addSubview(self.calender)
        self.calender.addSubview(self.previousButton)
        self.calender.addSubview(self.nextButton)
        
        self.previousButton.snp.makeConstraints { make in
            //make.top.equalToSuperview().offset(2)
            make.left.equalToSuperview().offset(15)
            make.centerY.equalTo(calender.calendarHeaderView.snp.centerY).offset(2)
        }
        self.nextButton.snp.makeConstraints { make in
            make.centerY.equalTo(previousButton.snp.centerY)
            make.right.equalToSuperview().offset(-15)
        }
    }
    
    private func setupButtonIconDisabled() {
        if self.calender.currentPage.fy.adding(.month, value: 1) >= maxDate {
            self.nextButton.isSelected = true
            return
        }
        if self.calender.currentPage <= minDate {
            self.previousButton.isSelected = true
            return
        }
        self.nextButton.isSelected = false
        self.previousButton.isSelected = false
    }
    
    private func request() {
        let dete = self.calender.currentPage
        if self.cacheDates.contains(dete) {
            return
        }
        self.requestBlock?(dete, { [weak self] (days: [String : Cell.Element]) in
            self?.cacheDates.append(dete)
            self?.days += days
            self?.calender.reloadData()
        })
    }
}

extension FSCalenderView: Booming.LevelStatusBarWindowShowUpable {
    
    public func show(animated: Bool, animation: (() -> Void)?, completion: ((Bool) -> Void)?) {
        let animationBlock = { [weak self] in
            let height = (self?.calenderHeight ?? 0.0) + (self?.titleLabelHeight ?? 0.0)
            self?.frame.origin = .init(x: 0, y: UIScreen.main.bounds.size.height - height)
            animation?()
        }
        if animated {
            UIView.animate(withDuration: 0.2, animations: animationBlock, completion: completion)
        } else {
            animationBlock()
            completion?(true)
        }
    }
    
    public func close(animated: Bool, animation: (() -> Void)?, completion: ((Bool) -> Void)?) {
        let animationBlock = {
            self.frame.origin = .init(x: 0, y: UIScreen.main.bounds.size.height)
            //self.removeFromSuperview()
            animation?()
        }
        if animated {
            UIView.animate(withDuration: 0.2, animations: animationBlock, completion: completion)
        } else {
            animationBlock()
            completion?(true)
        }
    }
    
    public var canCloseWhenTapOutSize: Bool {
        return true
    }
}

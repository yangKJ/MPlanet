//
//  DatePickerViewController.swift
//  FeatBox
//
//  Created by Condy on 2024/5/20.
//

import Foundation
import ProductLib
import Booming

/// 时间选择器窗口
public final class DatePickerViewController: LevelStatusBarWindowController {
    
    private(set) var finishSelectionBlock: ((Date) -> Void)?
    
    public func setFinishSelectionBlock(block: ((Date) -> Void)?) {
        self.finishSelectionBlock = block
    }
    
    private(set) var additionalButtonBlock: (() -> Void)?
    
    public func setAdditionalButtonBlock(block: (() -> Void)?) {
        self.additionalButtonBlock = block
    }
    
    private(set) var pickerDateDidChangeBlock: ((Date) -> Void)?
    
    public func setPickerDateDidChangeBlock(block: ((Date) -> Void)?) {
        self.pickerDateDidChangeBlock = block
    }
    
    public func set(date: Date?) {
        if let date = date {
            contentView?.pickerView.date = date
        }
    }
    
    public func set(maxDate: Date?) {
        contentView?.pickerView.maximumDate = maxDate
    }
    
    public func set(minDate: Date?) {
        contentView?.pickerView.minimumDate = minDate
    }
    
    public func set(title: String?) {
        contentView?.title = title
    }
    
    public func set(additionalTitle: String?) {
        contentView?.additionalTitle = additionalTitle
    }
    
    public func set(customizedView: UIView?) {
        contentView?.customizedView = customizedView
    }
    
    public override func initShowUpViewIfNeed() {
        let pickerView = ZQPickerViewContainer<DatePickerView>()
        self.showUpView = pickerView
        pickerView.setFinishSelectionBlock(block: { [weak self] (date) in
            self?.finishSelectionBlock?(date)
            self?.close()
        })
        pickerView.setAdditionalButtonBlock(block: { [weak self] in
            self?.additionalButtonBlock?()
            self?.close()
        })
        pickerView.pickerView.setPickerDateDidChangeBlock(block: pickerDateDidChangeBlock)
    }
    
    private var contentView: ZQPickerViewContainer<DatePickerView>? {
        self.showUpView as? ZQPickerViewContainer<DatePickerView>
    }
}

class DatePickerView: UIDatePicker, SubPickerView {
    
    typealias Element = Date
    
    var selectedValue: Date {
        get {
            return self.date
        }
    }
    
    private(set) var pickerDateDidChangeBlock: ((Element) -> Void)?
    func setPickerDateDidChangeBlock(block: ((Element) -> Void)?) {
        self.pickerDateDidChangeBlock = block
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setup()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        setup()
    }
    
    private func setup() {
        locale = Locale(identifier: "zh")
        datePickerMode = .date
        backgroundColor = UIColor.fy.backgroundGray
        if #available(iOS 13.4, *) {
            self.preferredDatePickerStyle = .wheels
        } else {
            // Fallback on earlier versions
        }
        addTarget(self, action: #selector(valueChanged(sender:)), for: .valueChanged)
    }
    
    @objc private func valueChanged(sender: UIDatePicker) {
        pickerDateDidChangeBlock?(sender.date)
    }
}

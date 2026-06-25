//
//  PickerViewController.swift
//  FeatBox
//
//  Created by Condy on 2024/5/20.
//

import Foundation
import ProductLib
import Booming

public struct PickerViewItem {
    var title: String?
    var dataSource: Any?
    var items: [PickerViewItem]?
    var defaultSelected: Bool = false
}

/// 自定义选择器窗口
public final class PickerViewController: LevelStatusBarWindowController {
    
    private var finishSelectionBlock: (([PickerViewItem]) -> Void)?
    
    public func setFinishSelectionBlock(block: @escaping ([PickerViewItem]) -> Void) {
        self.finishSelectionBlock = block
    }
    
    private(set) var additionalButtonBlock: (() -> Void)?
    
    public func setAdditionalButtonBlock(block: (() -> Void)?) {
        self.additionalButtonBlock = block
    }
    
    public func set(items: [PickerViewItem]) {
        contentView?.pickerView.items = items
    }
    
    public func set(title: String?) {
        contentView?.title = title
    }
    
    public func set(finishButtonTitle: String?) {
        contentView?.finishButtonTitle = finishButtonTitle
    }
    
    public func set(additionalTitle: String?) {
        contentView?.additionalTitle = additionalTitle
    }
    
    public func set(customizedView: UIView?) {
        contentView?.customizedView = customizedView
    }
    
    public override func initShowUpViewIfNeed() {
        let pickerView = ZQPickerViewContainer<CustomizedPickerView>()
        self.showUpView = pickerView
        pickerView.setFinishSelectionBlock(block: { [weak self] (items) in
            self?.finishSelectionBlock?(items)
            self?.close()
        })
        pickerView.setAdditionalButtonBlock(block: { [weak self] in
            self?.additionalButtonBlock?()
            self?.close()
        })
    }
    
    private var contentView: ZQPickerViewContainer<CustomizedPickerView>? {
        self.showUpView as? ZQPickerViewContainer<CustomizedPickerView>
    }
}

class CustomizedPickerView: UIPickerView, SubPickerView {
    
    typealias Element = [PickerViewItem]
    
    var selectedValue: [PickerViewItem] {
        return self.selectedRows.enumerated().compactMap {
            if let item = self.item(at: $0, row: $1) {
                return item
            }
            return nil
        }
    }
    
    private(set) var maxDeep: Int = 0
    private(set) var selectedRows = [Int]()
    
    var items: [PickerViewItem]? {
        didSet {
            self.maxDeep = 0
            self.calculateMaxDeep(items: items, deep: self.maxDeep)
            self.selectedRows.removeAll()
            for component in 0..<self.maxDeep {
                var hasAppended = false
                if let componetItems = self.items(at: component), componetItems.count > 0 {
                    for index in 0..<componetItems.count where componetItems[index].defaultSelected {
                        self.selectedRows.append(index)
                        hasAppended = true
                        break
                    }
                }
                if !hasAppended {
                    self.selectedRows.append(0)
                }
            }
            self.reload(animated: false)
        }
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.setup()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        self.setup()
    }
    
    private func setup() {
        self.backgroundColor = UIColor.fy.backgroundGray
        self.delegate = self
        self.dataSource = self
    }
    
    private func calculateMaxDeep(items: [PickerViewItem]?, deep: Int) {
        if (items?.count ?? 0) == 0 {
            self.maxDeep = max(self.maxDeep, deep)
        } else if let ds = items {
            for item in ds {
                self.calculateMaxDeep(items: item.items, deep: deep+1)
            }
        }
    }
    
    private func item(at component: Int, row: Int) -> PickerViewItem? {
        let items = self.items(at: component)
        return items?[safe: row]
    }
    
    private func items(at component: Int) -> [PickerViewItem]? {
        var items = self.items
        for index in 0..<component {
            let selectedRow = self.selectedRows[safe: index] ?? 0
            items = items?[safe: selectedRow]?.items
        }
        return items
    }
    
    private func reload(animated: Bool) {
        self.reloadAllComponents()
        self.selectedRows.enumerated().forEach {
            self.selectRow($1, inComponent: $0, animated: animated)
        }
    }
}

extension CustomizedPickerView: UIPickerViewDataSource {
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return self.items(at: component)?.count ?? 0
    }
    
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return self.maxDeep
    }
}

extension CustomizedPickerView: UIPickerViewDelegate {
    func pickerView(_ pickerView: UIPickerView, widthForComponent component: Int) -> CGFloat {
        return self.frame.size.width/CGFloat(self.maxDeep)
    }
    
    func pickerView(_ pickerView: UIPickerView, rowHeightForComponent component: Int) -> CGFloat {
        return 38
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        if self.selectedRows[safe: component] == row {
            return
        }
        self.selectedRows.remove(at: component)
        self.selectedRows.safeInsert(row, at: component)
        for index in component+1..<self.maxDeep {
            self.selectedRows.remove(at: index)
            self.selectedRows.safeInsert(0, at: index)
        }
        self.reload(animated: true)
    }
    
    func pickerView(_ pickerView: UIPickerView, viewForRow row: Int, forComponent component: Int, reusing view: UIView?) -> UIView {
        let label = BaseLabel()
        label.font = UIFont.fy.system_18
        label.textColor = UIColor.fy.black_333333
        label.numberOfLines = 0
        label.textAlignment = .center
        label.text = self.item(at: component, row: row)?.title ?? ""
        return label
    }
}

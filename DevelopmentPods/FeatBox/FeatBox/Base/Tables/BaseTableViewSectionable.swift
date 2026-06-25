//
//  BaseTableViewSectionable.swift
//  FeatBox
//
//  Created by Condy on 2024/5/20.
//

import Foundation
import ObjectiveC

public protocol BaseTableViewSectionable: AnyObject {
    
    var sectionHeaderTitle: String? { get set }
    var sectionFooterTitle: String? { get set }
    
    var sectionHeaderHeight: CGFloat { get set }
    var sectionFooterHeight: CGFloat { get set }
    
    var sectionHeaderBackgroundColor: UIColor? { get set }
    var sectionFooterBackgroundColor: UIColor? { get set }
    
    var sectionHeaderViewType: BaseTableViewHeaderFooterView.Type? { get set }
    var sectionHeaderViewNib: UINib? { get set }
    
    var sectionFooterViewType: BaseTableViewHeaderFooterView.Type? { get set }
    var sectionFooterViewNib: UINib? { get set }
    
    var cells: [BaseTableViewCellViewModelable] { get set }
}

open class BaseTableViewHeaderFooterSection: BaseTableViewSectionable {
    
    public var sectionHeaderBackgroundColor: UIColor?
    public var sectionFooterBackgroundColor: UIColor?
    
    public var cells: [BaseTableViewCellViewModelable]
    
    public init(cells: [BaseTableViewCellViewModelable]) {
        self.cells = cells
    }
}

extension BaseTableViewSectionable {
    
    public var sectionHeaderTitle: String? {
        get {
            return objc_getAssociatedObject(self, &BaseTableViewSectionableExtensionKeys.sectionHeaderTitle) as? String
        }
        set {
            objc_setAssociatedObject(self, &BaseTableViewSectionableExtensionKeys.sectionHeaderTitle, newValue, .OBJC_ASSOCIATION_COPY_NONATOMIC)
        }
    }
    
    public var sectionFooterTitle: String? {
        get {
            return objc_getAssociatedObject(self, &BaseTableViewSectionableExtensionKeys.sectionFooterTitle) as? String
        }
        set {
            objc_setAssociatedObject(self, &BaseTableViewSectionableExtensionKeys.sectionFooterTitle, newValue, .OBJC_ASSOCIATION_COPY_NONATOMIC)
        }
    }
    
    public var sectionHeaderHeight: CGFloat {
        get {
            return objc_getAssociatedObject(self, &BaseTableViewSectionableExtensionKeys.sectionHeaderHeight) as? CGFloat ?? 0.0
        }
        set {
            objc_setAssociatedObject(self, &BaseTableViewSectionableExtensionKeys.sectionHeaderHeight, newValue, .OBJC_ASSOCIATION_COPY_NONATOMIC)
        }
    }
    
    public var sectionFooterHeight: CGFloat {
        get {
            return objc_getAssociatedObject(self, &BaseTableViewSectionableExtensionKeys.sectionFooterHeight) as? CGFloat ?? 0.0
        }
        set {
            objc_setAssociatedObject(self, &BaseTableViewSectionableExtensionKeys.sectionFooterHeight, newValue, .OBJC_ASSOCIATION_COPY_NONATOMIC)
        }
    }
    
    public var sectionHeaderViewType: BaseTableViewHeaderFooterView.Type? {
        get {
            return objc_getAssociatedObject(self, &BaseTableViewSectionableExtensionKeys.sectionHeaderViewType) as? BaseTableViewHeaderFooterView.Type
        }
        set {
            objc_setAssociatedObject(self, &BaseTableViewSectionableExtensionKeys.sectionHeaderViewType, newValue, .OBJC_ASSOCIATION_COPY_NONATOMIC)
        }
    }
    
    public var sectionFooterViewType: BaseTableViewHeaderFooterView.Type? {
        get {
            return objc_getAssociatedObject(self, &BaseTableViewSectionableExtensionKeys.sectionFooterViewType) as? BaseTableViewHeaderFooterView.Type
        }
        set {
            objc_setAssociatedObject(self, &BaseTableViewSectionableExtensionKeys.sectionFooterViewType, newValue, .OBJC_ASSOCIATION_COPY_NONATOMIC)
        }
    }
    
    public var sectionHeaderViewNib: UINib? {
        get {
            return objc_getAssociatedObject(self, &BaseTableViewSectionableExtensionKeys.sectionHeaderViewNib) as? UINib
        }
        set {
            objc_setAssociatedObject(self, &BaseTableViewSectionableExtensionKeys.sectionHeaderViewNib, newValue, .OBJC_ASSOCIATION_COPY_NONATOMIC)
        }
    }
    
    public var sectionFooterViewNib: UINib? {
        get {
            return objc_getAssociatedObject(self, &BaseTableViewSectionableExtensionKeys.sectionFooterViewNib) as? UINib
        }
        set {
            objc_setAssociatedObject(self, &BaseTableViewSectionableExtensionKeys.sectionFooterViewNib, newValue, .OBJC_ASSOCIATION_COPY_NONATOMIC)
        }
    }
    
    public var sectionHeaderBackgroundColor: UIColor? {
        get {
            return objc_getAssociatedObject(self, &BaseTableViewSectionableExtensionKeys.sectionHeaderBackgroundColor) as? UIColor
        }
        set {
            objc_setAssociatedObject(self, &BaseTableViewSectionableExtensionKeys.sectionHeaderBackgroundColor, newValue, .OBJC_ASSOCIATION_COPY_NONATOMIC)
        }
    }
    
    public var sectionFooterBackgroundColor: UIColor? {
        get {
            return objc_getAssociatedObject(self, &BaseTableViewSectionableExtensionKeys.sectionFooterBackgroundColor) as? UIColor
        }
        set {
            objc_setAssociatedObject(self, &BaseTableViewSectionableExtensionKeys.sectionFooterBackgroundColor, newValue, .OBJC_ASSOCIATION_COPY_NONATOMIC)
        }
    }
}

private struct BaseTableViewSectionableExtensionKeys {
    static var sectionHeaderTitle: Void?
    static var sectionFooterTitle: Void?
    static var sectionHeaderHeight: Void?
    static var sectionFooterHeight: Void?
    static var sectionHeaderViewType: Void?
    static var sectionFooterViewType: Void?
    static var sectionHeaderViewNib: Void?
    static var sectionFooterViewNib: Void?
    static var sectionHeaderBackgroundColor: Void?
    static var sectionFooterBackgroundColor: Void?
}

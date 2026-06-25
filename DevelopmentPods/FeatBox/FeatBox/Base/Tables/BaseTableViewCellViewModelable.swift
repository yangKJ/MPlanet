//
//  BaseTableViewCellViewModelable.swift
//  Pods
//
//  Created by Condy on 2024/5/20.
//

import Foundation
import ObjectiveC
import RxCocoa

public protocol BaseTableViewCellViewModelable: AnyObject {
    
    var cellType: BaseTableViewCell.Type { get }
    
    var cellHeight: CGFloat? { get set }
    
    var datasource: Any? { get set }
    
    var sepratorLineColor: UIColor { get set }
    var sepratorLineHeight: CGFloat? { get set }
    var sepratorLineInsets: UIEdgeInsets { get set }
    
    /// 禁止重载Cell，防止刷新列表变动
    var prohibitedDequeueReusableCell: Bool { get set }
    
    /// Cell点击事件订阅
    var cellDidSelectedEvent: PublishRelay<Void> { get set }
    
    /// Cell点击事件回调
    func setCellDidSelected(block: (() -> Void)?)
}

extension BaseTableViewCellViewModelable {
    
    public var datasource: Any? {
        get {
            return objc_getAssociatedObject(self, &BaseTableViewCellViewModelableExtensionKeys.datasource)
        }
        set {
            objc_setAssociatedObject(self, &BaseTableViewCellViewModelableExtensionKeys.datasource, newValue, .OBJC_ASSOCIATION_COPY_NONATOMIC)
        }
    }
    
    public var cellHeight: CGFloat? {
        get {
            return objc_getAssociatedObject(self, &BaseTableViewCellViewModelableExtensionKeys.cellHeight) as? CGFloat
        }
        set {
            objc_setAssociatedObject(self, &BaseTableViewCellViewModelableExtensionKeys.cellHeight, newValue, .OBJC_ASSOCIATION_COPY_NONATOMIC)
        }
    }
    
    public var prohibitedDequeueReusableCell: Bool {
        get {
            return objc_getAssociatedObject(self, &BaseTableViewCellViewModelableExtensionKeys.prohibitedDequeueReusableCell) as? Bool ?? false
        }
        set {
            objc_setAssociatedObject(self, &BaseTableViewCellViewModelableExtensionKeys.prohibitedDequeueReusableCell, newValue, .OBJC_ASSOCIATION_COPY_NONATOMIC)
        }
    }
    
    public var sepratorLineHeight: CGFloat? {
        get {
            return objc_getAssociatedObject(self, &BaseTableViewCellViewModelableExtensionKeys.sepratorLineHeight) as? CGFloat
        }
        set {
            objc_setAssociatedObject(self, &BaseTableViewCellViewModelableExtensionKeys.sepratorLineHeight, newValue, .OBJC_ASSOCIATION_COPY_NONATOMIC)
        }
    }
    
    public var sepratorLineColor: UIColor {
        get {
            return objc_getAssociatedObject(self, &BaseTableViewCellViewModelableExtensionKeys.sepratorLineColor) as? UIColor ?? UIColor.fy.line
        }
        set {
            objc_setAssociatedObject(self, &BaseTableViewCellViewModelableExtensionKeys.sepratorLineColor, newValue, .OBJC_ASSOCIATION_COPY_NONATOMIC)
        }
    }
    
    public var sepratorLineInsets: UIEdgeInsets {
        get {
            return objc_getAssociatedObject(self, &BaseTableViewCellViewModelableExtensionKeys.sepratorLineInsets) as? UIEdgeInsets ?? .zero
        }
        set {
            objc_setAssociatedObject(self, &BaseTableViewCellViewModelableExtensionKeys.sepratorLineInsets, newValue, .OBJC_ASSOCIATION_COPY_NONATOMIC)
        }
    }
    
    public var cellDidSelectedEvent: PublishRelay<Void> {
        get {
            if let refresh = objc_getAssociatedObject(self, &BaseTableViewCellViewModelableExtensionKeys.cellDidSelectedEvent) {
                return refresh as! PublishRelay<Void>
            } else {
                let event: PublishRelay<Void> = PublishRelay<Void>()
                objc_setAssociatedObject(self, &BaseTableViewCellViewModelableExtensionKeys.cellDidSelectedEvent, event, .OBJC_ASSOCIATION_RETAIN_NONATOMIC)
                return event
            }
        }
        set {
            objc_setAssociatedObject(self, &BaseTableViewCellViewModelableExtensionKeys.cellDidSelectedEvent, newValue, .OBJC_ASSOCIATION_RETAIN_NONATOMIC)
        }
    }
    
    public func setCellDidSelected(block: (() -> Void)?) {
        self.cellDidSelectedBlock = block
    }
    
    var cellDidSelectedBlock: (() -> Void)? {
        get {
            return objc_getAssociatedObject(self, &BaseTableViewCellViewModelableExtensionKeys.cellDidSelectedBlock) as? (() -> Void)
        }
        set {
            objc_setAssociatedObject(self, &BaseTableViewCellViewModelableExtensionKeys.cellDidSelectedBlock, newValue, .OBJC_ASSOCIATION_COPY_NONATOMIC)
        }
    }
}

private struct BaseTableViewCellViewModelableExtensionKeys {
    static var datasource: Void?
    static var cellHeight: Void?
    static var prohibitedDequeueReusableCell: Void?
    static var sepratorLineColor: Void?
    static var sepratorLineHeight: Void?
    static var sepratorLineInsets: Void?
    static var cellDidSelectedEvent: Void?
    static var cellDidSelectedBlock: Void?
}

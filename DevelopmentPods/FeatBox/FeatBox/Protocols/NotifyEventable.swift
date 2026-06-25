//
//  NotifyEventable.swift
//  FeatBox
//
//  Created by Condy on 2025/6/1.
//

import Foundation
import RxSwift
import RxCocoa
import Combine

public protocol NotifyEventable: RawRepresentable where RawValue == String {
    
    func post(object: AnyObject?, userInfo: [AnyHashable: Any]?)
    
    var rx: Observable<Notification> { get }
    func rx(object: AnyObject?) -> Observable<Notification>
    
    @available(iOS 13.0, *)
    var publisher: AnyPublisher<Notification, Never> { get }
    @available(iOS 13.0, *)
    func publisher(object: AnyObject?) -> AnyPublisher<Notification, Never>
}

extension NotifyEventable {
    
    public func post(object: AnyObject? = nil, userInfo: [AnyHashable: Any]? = nil) {
        NotificationCenter.default.post(name: Notification.Name(rawValue: rawValue), object: object, userInfo: userInfo)
    }
    
    public var rx: Observable<Notification> {
        return NotificationCenter.default.rx.notification(Notification.Name(rawValue: rawValue))
    }
    
    public func rx(object: AnyObject? = nil) -> Observable<Notification> {
        return NotificationCenter.default.rx.notification(Notification.Name(rawValue: rawValue), object: object)
    }
    
    @available(iOS 13.0, *)
    public var publisher: AnyPublisher<Notification, Never> {
        NotificationCenter.default
            .publisher(for: Notification.Name(rawValue: rawValue))
            .eraseToAnyPublisher()
    }
    
    @available(iOS 13.0, *)
    public func publisher(object: AnyObject? = nil) -> AnyPublisher<Notification, Never> {
        NotificationCenter.default
            .publisher(for: Notification.Name(rawValue: rawValue), object: object)
            .eraseToAnyPublisher()
    }
}

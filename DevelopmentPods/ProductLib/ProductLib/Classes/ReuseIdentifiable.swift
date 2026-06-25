//
//  ReuseIdentifiable.swift
//  FeatBox
//
//  Created by Condy on 2023/5/20.
//

import Foundation

public protocol ReuseIdentifiable {
    
    static var reuseIdentifier: String { get }
    
    var reuseIdentifier: String { get }
}

extension ReuseIdentifiable {
    
    public static var reuseIdentifier: String {
        String(describing: self)
    }
    
    public var reuseIdentifier: String {
        String(describing: type(of: self))
    }
}

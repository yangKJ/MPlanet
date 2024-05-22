//
//  Identifierable.swift
//  FeatBox
//
//  Created by Condy on 2023/5/20.
//

import Foundation

public protocol Identifierable {
    
    static var identifier: String { get }
    
    var identifier: String { get }
}

extension Identifierable {
    
    public static var identifier: String {
        String(describing: self)
    }
    
    public var identifier: String {
        String(describing: self)
    }
}

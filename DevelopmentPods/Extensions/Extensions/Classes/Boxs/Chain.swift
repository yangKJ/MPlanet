//
//  ChainCreate.swift
//  FeatBox
//
//  Created by Condy on 2020/11/18.
//

import Foundation

/// 链式创建工具
public struct ChainObject<Chain> {
    let chain: Chain
    init(_ chain: Chain) {
        self.chain = chain
    }
}

extension ChainObject where Chain: NSObject {
    @discardableResult
    public static func make(_ make: @escaping (_ make: Chain) -> Void) -> Chain {
        let object = Chain.init()
        make(object)
        return object
    }
}

public protocol ChainObjectProtocol {
    associatedtype Target
    static var chain: ChainObject<Target>.Type { get }
    var chain: ChainObject<Target> { get }
}

extension ChainObjectProtocol {
    public static var chain: ChainObject<Self>.Type { ChainObject<Self>.self }
    public var chain: ChainObject<Self> { ChainObject(self) }
}

extension NSObject: ChainObjectProtocol { }

/// Chain shortcut generation
/// Example：
///
///        lazy var view = UIView.chain.make {
///            $0.backgroundColor = UIColor.red
///            $0.frame = CGRect(x: 100, y: 100, width: 100, height: 100)
///        }
///

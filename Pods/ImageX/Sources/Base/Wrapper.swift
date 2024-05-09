//
//  Wrapper.swift
//  Pods
//
//  Created by Condy on 2023/8/8.
//

import Foundation

/// Add the `img` prefix namespace
public struct ImageXEngine<Base> {
    public let base: Base
}

public protocol ImageXCompatible { }

extension ImageXCompatible {
    
    public var img: ImageXEngine<Self> {
        get { return ImageXEngine(base: self) }
        set { }
    }
    
    public var kj: ImageXEngine<Self> {
        img
    }
}

//
//  SelfAware.swift
//  Extensions
//
//  Created by Condy on 2023/5/20.
//

import Foundation
import UIKit

public protocol SelfAware {
    
    static func awake()
}

extension UIApplication {
    
    override open var next: UIResponder? {
        // Called before applicationDidFinishLaunching
        runOnce()
        return super.next
    }
    
    private func runOnce() {
        let typeCount = Int(objc_getClassList(nil, 0))
        let types = UnsafeMutablePointer<AnyClass>.allocate(capacity: typeCount)
        let autoreleasingTypes = AutoreleasingUnsafeMutablePointer<AnyClass>(types)
        objc_getClassList(autoreleasingTypes, Int32(typeCount))
        for index in 0 ..< typeCount {
            (types[index] as? SelfAware.Type)?.awake()
        }
        types.deallocate()
        //types.deallocate(capacity: typeCount)
    }
}

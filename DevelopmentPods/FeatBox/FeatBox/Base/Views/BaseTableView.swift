//
//  BaseTableView.swift
//  FeatBox
//
//  Created by Condy on 2024/5/20.
//

import Foundation

open class BaseTableView: UITableView {
    
    public var shouldRecieveTouches = false
    
    open override func touchesMoved(_ touches: Set<UITouch>, with event: UIEvent?) {
        if shouldRecieveTouches {
            self.next?.touchesMoved(touches, with: event)
        }
        super.touchesMoved(touches, with: event)
    }
    
    open override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        if shouldRecieveTouches {
            self.next?.touchesBegan(touches, with: event)
        }
        super.touchesBegan(touches, with: event)
    }
    
    open override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        if shouldRecieveTouches {
            self.next?.touchesEnded(touches, with: event)
        }
        super.touchesEnded(touches, with: event)
    }
    
    open override func touchesCancelled(_ touches: Set<UITouch>, with event: UIEvent?) {
        if shouldRecieveTouches {
            self.next?.touchesCancelled(touches, with: event)
        }
        super.touchesCancelled(touches, with: event)
    }
    
    open override func touchesShouldBegin(_ touches: Set<UITouch>, with event: UIEvent?, in view: UIView) -> Bool {
        return super.touchesShouldBegin(touches, with: event, in: view)
    }
}

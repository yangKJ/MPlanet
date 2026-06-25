//
//  SmartCodable+Rx.swift
//  FeatBox
//
//  Created by Condy on 2025/1/10.
//

import Foundation
import SmartCodable
import RxSwift

public extension Observable where Element: Any {
    
    @discardableResult func deserialized<T>(_ type: T.Type) -> Observable<T?> where T: SmartCodableX {
        return self.map { element -> T? in
            if let element = element as? String {
                return T.deserialize(from: element)
            } else if let element = element as? Data {
                return T.deserialize(from: element)
            } else if let element = element as? [String: Any] {
                return T.deserialize(from: element)
            } else {
                return nil
            }
        }
    }
    
    @discardableResult func deserialized<T>(_ type: [T].Type) -> Observable<[T]> where T: SmartCodableX {
        return self.map { element -> [T] in
            if let element = element as? String {
                return [T].deserialize(from: element) ?? []
            } else if let element = element as? Data {
                return [T].deserialize(from: element) ?? []
            } else if let element = element as? [String: Any] {
                return [T].deserialize(from: element) ?? []
            }  else {
                return []
            }
        }
    }
}

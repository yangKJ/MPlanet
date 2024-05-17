//
//  MournType.swift
//  FeatBox
//
//  Created by Condy on 2024/5/10.
//

import Foundation
import ProductLib

/// 悼念模式
public enum MournType: String {
    case none = "MOURN_NONE"
    case home = "MOURN_HOME"
    case all  = "MOURN_ALL"
}

extension MournType {
    
    public static func hasMourning() -> Bool {
        switch AppUserSettings.mournType {
        case .none:
            break
        case .home, .all:
            let millisecondTime = Date().fy.millisecondTimeIntervalSince1970
            if AppUserSettings.mournStartTime <= millisecondTime, AppUserSettings.mournEndTime > millisecondTime {
                return true
            }
        }
        return false
    }
    
    public static func closeMourned() -> Bool {
        switch AppUserSettings.mournType {
        case .none:
            return true
        case .home:
            return true
        case .all:
            let millisecondTime = Date().fy.millisecondTimeIntervalSince1970
            if millisecondTime >= AppUserSettings.mournEndTime {
                return true
            }
        }
        return false
    }
}

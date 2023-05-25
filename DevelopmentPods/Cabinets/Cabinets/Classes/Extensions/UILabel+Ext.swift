//
//  UILabel+Ext.swift
//  Cabinets
//
//  Created by Condy on 2023/5/20.
//

import Foundation

extension BoxWrapper where Base: UILabel {
    
    /// 判断多行or单行文本内容是否被截断<是否显示过省略号内容>
    public var isTruncated: Bool {
        guard let labelText = base.text as? NSString else {
            return false
        }
        let rect = CGSize(width: base.bounds.width, height: CGFloat.greatestFiniteMagnitude)
        let textSize = labelText.boundingRect(with: rect,
                                              options: .usesLineFragmentOrigin,
                                              attributes: [NSAttributedString.Key.font: base.font],
                                              context: nil)
        let textLines = Int(ceil(CGFloat(textSize.height) / base.font.lineHeight))
        
        var showLines = Int(floor(CGFloat(base.bounds.size.height) / base.font.lineHeight))
        if base.numberOfLines != 0 {
            showLines = min(showLines, base.numberOfLines)
        }
        return textLines > showLines
    }
}

//
//  UILabel+.swift
//  DesignSystem
//
//  Created by 이정원 on 7/21/25.
//  Copyright © 2025 Darayo. All rights reserved.
//

import UIKit

public extension UILabel {
    func lineHeight(_ lineHeight: CGFloat, alginment: NSTextAlignment = .center) {
        guard let text else { return }
        let style = NSMutableParagraphStyle()
        style.maximumLineHeight = lineHeight
        style.minimumLineHeight = lineHeight
        style.alignment = alginment
        
        let attributes: [NSAttributedString.Key: Any] = [
            .paragraphStyle: style,
            .baselineOffset: (lineHeight - font.lineHeight) / 4,
        ]
        attributedText = NSAttributedString(string: text,attributes: attributes)
    }
}

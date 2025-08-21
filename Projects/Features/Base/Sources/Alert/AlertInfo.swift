//
//  AlertInfo.swift
//  Base
//
//  Created by 이정원 on 8/21/25.
//  Copyright © 2025 Darayo. All rights reserved.
//

import SwiftUI
import DesignSystem

public protocol AlertPresentable: Equatable {
    var alertInfo: AlertInfo { get }
}

public struct AlertInfo {
    public struct Box {
        let upperText: String
        let highlightText: String
        let lowerText: String
        
        public init(
            upperText: String,
            highlightText: String,
            lowerText: String
        ) {
            self.upperText = upperText
            self.highlightText = highlightText
            self.lowerText = lowerText
        }
    }
    
    let icon: Image
    let iconColor: Color
    let title: String
    let box: Box?
    let message: String?
    let hasCloseButton: Bool
    let buttonTitle: String
    
    public init(
        icon: Image,
        iconColor: Color = .grey4,
        title: String,
        box: Box? = nil,
        message: String? = nil,
        hasCloseButton: Bool,
        buttonTitle: String
    ) {
        self.icon = icon
        self.iconColor = iconColor
        self.title = title
        self.box = box
        self.message = message
        self.hasCloseButton = hasCloseButton
        self.buttonTitle = buttonTitle
    }
}

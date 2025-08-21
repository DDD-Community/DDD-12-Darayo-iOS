//
//  CustomAlertView.swift
//  DesignSystem
//
//  Created by 이정원 on 7/25/25.
//  Copyright © 2025 Darayo. All rights reserved.
//

import SwiftUI

public struct CustomAlertView: View {
    private let icon: Image
    private let iconColor: Color
    private let title: String
    private let message: String?
    private let upperText: String?
    private let highlightText: String?
    private let lowerText: String?
    private let buttonTitle: String
    private let action: () -> Void
    private let closeAction: (() -> Void)?
    
    public init(
        icon: Image,
        iconColor: Color,
        title: String,
        message: String?,
        upperText: String?,
        highlightText: String?,
        lowerText: String?,
        buttonTitle: String,
        action: @escaping () -> Void,
        closeAction: (() -> Void)?
    ) {
        self.icon = icon
        self.iconColor = iconColor
        self.title = title
        self.message = message
        self.upperText = upperText
        self.highlightText = highlightText
        self.lowerText = lowerText
        self.buttonTitle = buttonTitle
        self.action = action
        self.closeAction = closeAction
    }
    
    public var body: some View {
        VStack(spacing: 0) {
            HStack(spacing: 0) {
                Spacer()
                    .frame(height: 24)
                closeButton
                    .renderedIf(closeAction != nil)
            }
            
            icon
                .renderingMode(.template)
                .resizable()
                .foregroundStyle(iconColor)
                .frame(width: 40, height: 40)
            
            Text(title)
                .pretendard(style: .title2)
                .foregroundStyle(Color.white)
                .padding(.top, 14)
            
            boxSection
                .renderedIf(hasBox)
                .padding(.top, 10)
            
            if let message {
                Text(message)
                    .pretendard(style: .body4)
                    .padding(.top, 10)
            }
            
            button
                .padding(.top, 20)
        }
        .padding(16)
        .frame(maxWidth: 300)
        .background(Color.grey6)
        .clipShape(RoundedRectangle(cornerRadius: 8))
    }
}

private extension CustomAlertView {
    var hasBox: Bool {
        upperText != nil && highlightText != nil && lowerText != nil
    }
}

private extension CustomAlertView {
    var closeButton: some View {
        Button {
            closeAction?()
        } label: {
            Image.iconClose
                .resizable()
                .frame(width: 24, height: 24)
        }
    }
    
    var boxSection: some View {
        VStack(spacing: 4) {
            Text(upperText ?? "")
                .pretendard(style: .body4)
                .foregroundStyle(Color.grey3)
                .multilineTextAlignment(.center)
            
            Text(highlightText ?? "")
                .pretendard(style: .body2)
                .foregroundStyle(Color.white)
                .multilineTextAlignment(.center)
            
            Text(lowerText ?? "")
                .pretendard(style: .body4)
                .foregroundStyle(Color.grey3)
                .multilineTextAlignment(.center)
        }
        .frame(maxWidth: .infinity)
        .padding(14)
        .background(Color.background2)
        .clipShape(RoundedRectangle(cornerRadius: 6))
    }
    
    var button: some View {
        Button(buttonTitle, action: action)
            .buttonStyle(.festibee)
    }
}

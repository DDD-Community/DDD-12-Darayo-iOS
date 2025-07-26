//
//  CustomAlertView.swift
//  DesignSystem
//
//  Created by 이정원 on 7/25/25.
//  Copyright © 2025 Darayo. All rights reserved.
//

import SwiftUI

public struct CustomAlertView: View {
    private let icon: Image?
    private let title: String
    private let message: String?
    private let buttonTitle: String
    private let action: () -> Void
    private let closeAction: () -> Void
    
    public init(
        icon: Image? = nil,
        title: String,
        message: String? = nil,
        buttonTitle: String,
        action: @escaping () -> Void,
        closeAction: @escaping () -> Void
    ) {
        self.icon = icon
        self.title = title
        self.message = message
        self.buttonTitle = buttonTitle
        self.action = action
        self.closeAction = closeAction
    }
    
    public var body: some View {
        VStack(spacing: 0) {
            HStack(spacing: 0) {
                Spacer()
                closeButton
            }
            
            if let icon {
                icon
                    .resizable()
                    .frame(width: 40, height: 40)
            }
            
            Text(title)
                .pretendard(style: .title2)
                .padding(.top, 20)
            
            if let message {
                Text(message)
                    .pretendard(style: .body4)
                    .padding(.top, 10)
            }
            
            button
                .padding(.top, 30)
        }
        .padding(16)
        .frame(maxWidth: 300)
        .background(Color.background2)
        .clipShape(RoundedRectangle(cornerRadius: 8))
    }
}

private extension CustomAlertView {
    var closeButton: some View {
        Button(action: closeAction) {
            Image.iconClose
                .resizable()
                .frame(width: 24, height: 24)
        }
    }
    
    var button: some View {
        Button(buttonTitle, action: action)
            .buttonStyle(.festibee)
    }
}

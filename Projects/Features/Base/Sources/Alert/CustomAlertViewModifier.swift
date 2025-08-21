//
//  CustomAlertViewModifier.swift
//  Base
//
//  Created by 이정원 on 7/25/25.
//  Copyright © 2025 Darayo. All rights reserved.
//

import SwiftUI
import ComposableArchitecture
import DesignSystem

struct CustomAlertViewModifier<AlertCase: AlertPresentable>: ViewModifier {
    private let item: Binding<StoreOf<CustomAlert<AlertCase>>?>
    private let onDismiss: () -> Void
    
    init(
        item: Binding<StoreOf<CustomAlert<AlertCase>>?>,
        onDismiss: @escaping () -> Void
    ) {
        self.item = item
        self.onDismiss = onDismiss
    }
    
    func body(content: Content) -> some View {
        switch item.wrappedValue {
        case .none: content
        case .some(let store):
            ZStack {
                content
                    .blur(radius: 4)
                    .allowsHitTesting(false)
                
                Color.background1
                    .opacity(0.2)
                    .ignoresSafeArea()
            
                customAlertView(store: store)
            }
        }
    }
    
    private func customAlertView(store: StoreOf<CustomAlert<AlertCase>>) -> some View {
        let alertInfo = store.alertCase.alertInfo
        
        return CustomAlertView(
            icon: alertInfo.icon,
            iconColor: alertInfo.iconColor,
            title: alertInfo.title,
            message: alertInfo.message,
            upperText: alertInfo.box?.upperText,
            highlightText: alertInfo.box?.highlightText,
            lowerText: alertInfo.box?.lowerText,
            buttonTitle: alertInfo.buttonTitle
        ) {
            store.send(.buttonTapped(store.alertCase))
            onDismiss()
        } closeAction: {
            onDismiss()
        }
    }
}

public extension View {
    func customAlert<AlertCase>(
        _ item: Binding<StoreOf<CustomAlert<AlertCase>>?>
    ) -> some View {
        modifier(
            CustomAlertViewModifier(item: item) {
                item.wrappedValue = nil
            }
        )
    }
}

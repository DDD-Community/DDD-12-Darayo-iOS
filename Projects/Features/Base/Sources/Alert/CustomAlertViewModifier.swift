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

struct CustomAlertViewModifier: ViewModifier {
    private let item: Binding<StoreOf<CustomAlert>?>
    private let icon: Image?
    private let onDismiss: () -> Void
    
    init(
        item: Binding<StoreOf<CustomAlert>?>,
        icon: Image?,
        onDismiss: @escaping () -> Void
    ) {
        self.item = item
        self.icon = icon
        self.onDismiss = onDismiss
    }
    
    func body(content: Content) -> some View {
        ZStack {
            content
            
            if let store = item.wrappedValue {
                Color.background1
                    .opacity(0.4)
                    .ignoresSafeArea()
                    .blur(radius: 10)
                
                CustomAlertView(
                    icon: icon,
                    title: store.title,
                    message: store.message,
                    buttonTitle: store.buttonTitle,
                    action: {
                        store.send(.buttonTapped)
                        onDismiss()
                    },
                    closeAction: {
                        store.send(.closeButtonTapped)
                        onDismiss()
                    }
                )
            }
        }
    }
}

public extension View {
    func customAlert(
        _ item: Binding<StoreOf<CustomAlert>?>,
        icon: Image? = nil
    ) -> some View {
        modifier(
            CustomAlertViewModifier(item: item, icon: icon) {
                item.wrappedValue = nil
            }
        )
    }
}

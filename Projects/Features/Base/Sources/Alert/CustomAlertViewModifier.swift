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
    @Binding private var item: StoreOf<CustomAlert<AlertCase>>?
    
    init(item: Binding<StoreOf<CustomAlert<AlertCase>>?>) {
        self._item = item
    }
    
    func body(content: Content) -> some View {
        switch item {
        case .none: content
        case .some(let store):
            ZStack {
                content
                    .blur(radius: 4)
                    .allowsHitTesting(false)
                
                Color.background1
                    .opacity(0.2)
                    .ignoresSafeArea(.all)
                    .onTapGesture { item = nil }
            
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
            item = nil
        } closeAction: {
            item = nil
        }
        .background(Color.clear)
    }
}

public extension View {
    func customAlert<AlertCase>(
        _ item: Binding<StoreOf<CustomAlert<AlertCase>>?>
    ) -> some View {
        modifier(CustomAlertViewModifier(item: item))
    }
}

//
//  TermsOfServiceView.swift
//  MyPage
//
//  Created by 이정원 on 7/6/25.
//  Copyright © 2025 Darayo. All rights reserved.
//

import SwiftUI
import ComposableArchitecture
import DesignSystem

public struct TermsOfServiceView: View {
    private let store: StoreOf<TermsOfServiceFeature>
    
    public init(store: StoreOf<TermsOfServiceFeature>) {
        self.store = store
    }
    
    public var body: some View {
        ScrollView {
            Text(store.text)
                .pretendard(style: .caption2)
                .padding(.horizontal, 16)
                .padding(.top, 16)
                .padding(.bottom, 200)
        }
        .navigation(title: "이용약관") {
            store.send(.backButtonTapped)
        }
        .gradient(height: 184)
        .background(Color.background1)
    }
}

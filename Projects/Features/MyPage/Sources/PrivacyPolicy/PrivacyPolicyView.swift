//
//  PrivacyPolicyView.swift
//  MyPage
//
//  Created by 이정원 on 7/6/25.
//  Copyright © 2025 Darayo. All rights reserved.
//

import SwiftUI
import ComposableArchitecture
import DesignSystem

public struct PrivacyPolicyView: View {
    private let store: StoreOf<PrivacyPolicyFeature>
    
    public init(store: StoreOf<PrivacyPolicyFeature>) {
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
        .navigation(title: "개인정보 처리방침") {
            store.send(.backButtonTapped)
        }
        .gradient(height: 184)
        .background(Color.background1)
    }
}

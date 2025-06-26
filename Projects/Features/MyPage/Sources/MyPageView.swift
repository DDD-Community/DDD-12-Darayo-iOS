//
//  MyPageView.swift
//  MyPage
//
//  Created by 이정원 on 6/23/25.
//  Copyright © 2025 Darayo. All rights reserved.
//

import SwiftUI
import ComposableArchitecture
import DesignSystem

public struct MyPageView: View {
    private let store: StoreOf<MyPageFeature>
    
    public init(store: StoreOf<MyPageFeature>) {
        self.store = store
    }
    
    public var body: some View {
        VStack {
            Spacer()
            Text("마이페이지")
                .pretendard(style: .title1)
                .foregroundStyle(Color.white)
                .padding(.bottom, 24)
            Spacer()
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .background(Color.background1)
    }
}

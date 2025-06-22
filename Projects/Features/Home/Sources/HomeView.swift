//
//  HomeView.swift
//  Home
//
//  Created by 이정원 on 6/22/25.
//  Copyright © 2025 Darayo. All rights reserved.
//

import SwiftUI
import ComposableArchitecture
import DesignSystem

public struct HomeView: View {
    private let store: StoreOf<HomeFeature>
    
    public init(store: StoreOf<HomeFeature>) {
        self.store = store
    }
    
    public var body: some View {
        VStack {
            Spacer()
            Text("홈")
                .pretendard(style: .title1)
                .foregroundStyle(Color.white)
                .padding(.bottom, 24)
            Spacer()
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .background(Color.background1)
    }
}

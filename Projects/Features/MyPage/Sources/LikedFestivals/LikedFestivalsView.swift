//
//  LikedFestivalsView.swift
//  MyPage
//
//  Created by 이정원 on 8/11/25.
//  Copyright © 2025 Darayo. All rights reserved.
//

import SwiftUI
import ComposableArchitecture
import DesignSystem

public struct LikedFestivalsView: View {
    private let store: StoreOf<LikedFestivalsFeature>
    
    public init(store: StoreOf<LikedFestivalsFeature>) {
        self.store = store
    }
    
    public var body: some View {
        FestivalListView(
            festivals: store.festivals,
            isLoading: store.isLoading
        ) { festival in
            store.send(.festivalTapped(festival))
        } deleteAction: { _ in
            
        }
        .navigation(title: "좋아요한 페스티벌 목록") {
            store.send(.backButtonTapped)
        }
        .background(Color.background1)
        .onAppear { store.send(.onAppear) }
    }
}

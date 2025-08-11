//
//  SubscribedFestivalsView.swift
//  MyPage
//
//  Created by 이정원 on 7/5/25.
//  Copyright © 2025 Darayo. All rights reserved.
//

import SwiftUI
import ComposableArchitecture
import DesignSystem

public struct SubscribedFestivalsView: View {
    private let store: StoreOf<SubscribedFestivalsFeature>
    
    public init(store: StoreOf<SubscribedFestivalsFeature>) {
        self.store = store
    }
    
    public var body: some View {
        FestivalListView(
            type: .subscribed,
            festivals: store.festivals,
            isOn: store.isEnabled,
            isLoading: store.isLoading
        ) { festival in
            store.send(.festivalTapped(festival))
        } iconAction: { festival in
            store.send(.noticiationButtonTapped(festival))
        }
        .navigation(title: "알림 설정한 페스티벌 목록") {
            store.send(.backButtonTapped)
        }
        .background(Color.background1)
        .onAppear { store.send(.onAppear) }
        .refreshable { store.send(.onAppear) }
    }
}

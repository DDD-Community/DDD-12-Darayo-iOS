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
import Base

public struct LikedFestivalsView: View {
    @Bindable private var store: StoreOf<LikedFestivalsFeature>
    
    public init(store: StoreOf<LikedFestivalsFeature>) {
        self.store = store
    }
    
    public var body: some View {
        FestivalListView(
            type: .liked,
            festivals: store.festivals,
            isOn: store.isFavorite,
            isLoading: store.isLoading
        ) { festival in
            store.send(.festivalTapped(festival))
        } iconAction: { festival in
            store.send(.likeButtonTapped(festival))
        }
        .navigation(title: "좋아요한 페스티벌 목록") {
            store.send(.backButtonTapped)
        }
        .background(Color.background1)
        .customAlert($store.scope(state: \.alert, action: \.alert))
        .onAppear { store.send(.onAppear) }
        .refreshable { store.send(.onAppear) }
    }
}

extension LikedFestivalsFeature.AlertCase: AlertPresentable {
    public var alertInfo: AlertInfo {
        switch self {
        case .error(let error):
            switch error.type {
            case .noInternet: return .noInternet
            default: return .error(error, buttonTitle: "확인")
            }
        }
    }
}

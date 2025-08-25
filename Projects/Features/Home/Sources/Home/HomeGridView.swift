//
//  HomeGridView.swift
//  Home
//
//  Created by 이정원 on 6/29/25.
//  Copyright © 2025 Darayo. All rights reserved.
//

import SwiftUI
import ComposableArchitecture
import DesignSystem

struct HomeGridView: View {
    @Bindable private var store: StoreOf<HomeFeature>
    
    init(store: StoreOf<HomeFeature>) {
        self.store = store
    }
    
    var body: some View {
        ZStack {
            festivalGridView
                .refreshable {
                    store.send(.onRefresh)
                }
                .animation(.easeInOut(duration: 0.3), value: store.festivals)
                .renderedIf(shouldShowGridView)
            
            Color.background1
                .renderedIf(shouldShowEmptyView)
        }
        .animation(.easeInOut(duration: 0.3), value: store.festivals.isEmpty)
        .background(Color.background1)
    }
}

private extension HomeGridView {
    var shouldShowEmptyView: Bool {
        return !store.isLoading && store.festivals.isEmpty
    }
    
    var shouldShowGridView: Bool {
        !shouldShowEmptyView
    }
}

private extension HomeGridView {
    var festivalGridView: some View {
        ScrollView(store.isLoading ? [] : [.vertical]) {
            FestivalGridView(
                festivals: store.festivals,
                isFavorite: store.isFavorite,
                isLoading: store.isLoading
            ) { festival in
                store.send(.festivalTapped(festival))
            } heartButtonTapped: { festival in
                store.send(.heartButtonTapped(festival))
            }
            .padding(.horizontal, 16)
            .padding(.bottom, 100)
            .padding(.bottom, 24)
            .padding(.top, 12)
        }
    }
}

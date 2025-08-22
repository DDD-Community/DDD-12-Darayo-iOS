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
            
            emptyView
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
    
    var emptyView: some View {
        VStack(spacing: 0) {
            Image.star
            
            Text("아직 좋아요한 페스티벌이 없어요!")
                .pretendard(style: .title2)
                .foregroundStyle(Color.white)
                .padding(.top, 22)
            
            Text("관심있는 페스티벌을\n좋아요하고, 소식을 받아보세요 :)")
                .pretendard(style: .body4)
                .multilineTextAlignment(.center)
                .foregroundStyle(Color.grey4)
                .padding(.top, 10)
        }
        .padding(.bottom, 10)
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .padding(.bottom, 24)
    }
}

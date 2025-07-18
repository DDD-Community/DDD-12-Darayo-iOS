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
        VStack(spacing: 0) {
            favoritesButton(isFiltered: $store.isFiltered)
                .padding(.bottom, 10)
            
            ZStack {
                ZStack {
                    switch store.isFiltered {
                    case true:
                        festivalGridView
                    case false:
                        festivalGridView
                            .refreshable {
                                store.send(.onRefresh)
                            }
                    }
                }
                .renderedIf(shouldShowGridView)
                
                emptyView
                    .renderedIf(shouldShowEmptyView)
            }
        }
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
        }
        .id(store.isFiltered)
    }
    
    func favoritesButton(isFiltered: Binding<Bool>) -> some View {
        let icon: Image = switch isFiltered.wrappedValue {
        case true: Image.iconChecked
        case false: Image.iconUnchecked
        }
        
        return Button {
            isFiltered.wrappedValue.toggle()
        } label: {
            HStack(spacing: 2) {
                icon
                    .resizable()
                    .frame(width: 24, height: 24)
                
                Text("좋아요한 페스티벌")
                    .pretendard(style: .body4)
                    .foregroundStyle(Color.grey3)
            }
        }
        .buttonStyle(.plain)
        .frame(maxWidth: .infinity, alignment: .leading)
        .padding(.leading, 16)
    }
    
    var emptyView: some View {
        VStack(spacing: 0) {
            Image.iconPetalBackground
                .resizable()
                .frame(width: 109, height: 120)
            
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

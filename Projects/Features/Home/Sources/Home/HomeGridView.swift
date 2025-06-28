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
        VStack(spacing: 10) {
            favoritesButton(isFiltered: $store.isFiltered)
            
            ScrollView {
                FestivalGridView(festivals: store.festivals) { festival in
                    store.send(.festivalTapped(festival))
                }
                .padding(.horizontal, 16)
                .padding(.bottom, 100)
                .padding(.bottom, 24)
            }
        }
        .background(Color.background1)
    }
}

private extension HomeGridView {
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
}

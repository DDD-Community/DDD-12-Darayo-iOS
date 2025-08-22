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
    @Bindable private var store: StoreOf<HomeFeature>
    
    public init(store: StoreOf<HomeFeature>) {
        self.store = store
    }
    
    public var body: some View {
        VStack(spacing: 0) {
            navigationBar
            ZStack {
                HomeGridView(store: store)
                    .opacity(opacity(.grid))
            }
        }
        .background(Color.background1)
        .onAppear {
            if store.selectedDate == nil {
                store.send(.dateSelected(Date()))
            }
            store.send(.onAppear)
        }
    }
}

private extension HomeView {
    func opacity(_ mode: HomeFeature.DisplayMode) -> CGFloat {
        mode == store.displayMode ? 1 : 0
    }
    
    var navigationBar: some View {
        HStack {
            Image.logo
            Spacer()
            myPageButton
        }
        .padding(.vertical, 10)
        .padding(.horizontal, 16)
    }
    
    var myPageButton: some View {
        Button {
            store.send(.myPageButtonTapped)
        } label: {
            Image.iconMyPage
                .renderingMode(.template)
                .resizable()
                .frame(width: 24, height: 24)
                .foregroundStyle(Color.grey4)
        }
    }
}

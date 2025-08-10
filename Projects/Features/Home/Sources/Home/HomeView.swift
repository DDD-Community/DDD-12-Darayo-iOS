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
            HomeGridView(store: store)
        }
        .background(Color.background1)
        .onAppear { store.send(.onAppear) }
    }
}

private extension HomeView {
    var navigationBar: some View {
        HStack {
            Image.logo
                .resizable()
                .aspectRatio(contentMode: .fit)
                .frame(width: 106)
                .padding(.leading, 16)
            Spacer()
            myPageButton
        }
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
                .padding(.vertical, 10)
                .padding(.trailing, 16)
        }
    }
}

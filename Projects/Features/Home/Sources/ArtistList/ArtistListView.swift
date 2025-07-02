//
//  ArtistListView.swift
//  Home
//
//  Created by 이정원 on 7/2/25.
//  Copyright © 2025 Darayo. All rights reserved.
//

import SwiftUI
import ComposableArchitecture
import DesignSystem

public struct ArtistListView: View {
    private let store: StoreOf<ArtistListFeature>
    
    public init(store: StoreOf<ArtistListFeature>) {
        self.store = store
    }
    
    public var body: some View {
        VStack(spacing: 0) {
            navigationBar
            dayListView
            Spacer()
        }
        .navigationBarBackButtonHidden()
        .background(Color.background1)
    }
}

private extension ArtistListView {
    var navigationBar: some View {
        ZStack(alignment: .leading) {
            Text("아티스트 리스트")
                .pretendard(style: .title2)
                .frame(maxWidth: .infinity)
                .frame(height: 56)
            
            Button {
                store.send(.backButtonTapped)
            } label: {
                Image.iconArrowLeft
                    .resizable()
                    .frame(width: 24, height: 24)
                    .padding(16)
            }
        }
    }
    
    var dayListView: some View {
        DayListView(
            totalDays: store.totalDays,
            selectedDay: store.selectedDay
        ) { day in
            store.send(.dayButtonTapped(day))
        }
    }
}

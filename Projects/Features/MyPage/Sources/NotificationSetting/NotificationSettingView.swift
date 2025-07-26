//
//  NotificationSettingView.swift
//  MyPage
//
//  Created by 이정원 on 7/5/25.
//  Copyright © 2025 Darayo. All rights reserved.
//

import SwiftUI
import ComposableArchitecture
import DesignSystem

public struct NotificationSettingView: View {
    private let store: StoreOf<NotificationSettingFeature>
    
    public init(store: StoreOf<NotificationSettingFeature>) {
        self.store = store
    }
    
    public var body: some View {
        VStack(spacing: 0) {
            navigationBar
            
            switch store.isLoading {
            case true: shimmerListView
            case false:
                switch store.festivals.isEmpty {
                case true: emptyView
                case false: subscribedFestivalListView
                }
            }
        }
        .background(Color.background1.ignoresSafeArea())
        .navigationBarBackButtonHidden()
        .animation(.easeInOut(duration: 0.2), value: store.festivals.isEmpty)
        .onAppear {
            store.send(.onAppear)
        }
    }
}

private extension NotificationSettingView {
    var navigationBar: some View {
        ZStack(alignment: .leading) {
            Text("알림 설정한 페스티벌 목록")
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
    
    var shimmerListView: some View {
        ScrollView([]) {
            VStack(spacing: 12) {
                ForEach(0..<20, id: \.self) { _ in
                    ShimmerView()
                        .frame(maxWidth: .infinity)
                        .frame(height: 88)
                        .clipShape(RoundedRectangle(cornerRadius: 4))
                }
            }
            .padding(16)
        }
    }
    
    var subscribedFestivalListView: some View {
        ScrollView {
            SubscribedFestivalListView(festivals: store.festivals) { festival in
                store.send(.noticiationButtonTapped(festival))
            }
            .padding(16)
        }
        .animation(.easeInOut, value: store.festivals)
    }
    
    var emptyView: some View {
        VStack(spacing: 22) {
            Image.star
            Text("알림 설정한 페스티벌이 없어요!")
                .pretendard(style: .title2)
                .foregroundStyle(Color.white)
        }
        .frame(maxHeight: .infinity)
    }
}

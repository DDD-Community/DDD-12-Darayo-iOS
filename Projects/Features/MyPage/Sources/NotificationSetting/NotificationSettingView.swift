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
    @Bindable private var store: StoreOf<NotificationSettingFeature>
    
    public init(store: StoreOf<NotificationSettingFeature>) {
        self.store = store
    }
    
    public var body: some View {
        VStack(spacing: 0) {
            navigationBar
            
            ScrollView {
                VStack(spacing: 12) {
                    ForEach(store.festivals) { festival in
                        FestivalNotificationCellView(
                            festival: festival,
                            toggleAction: {
                                store.send(.toggleNotification(id: festival.id, isOn: !festival.isNotificationOn))
                            }
                        )
                    }
                }
                .padding(.horizontal, 16)
                .padding(.top, 16)
                .padding(.bottom, 24)
            }
        }
        .background(Color.background1.ignoresSafeArea())
        .navigationBarBackButtonHidden()
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
}

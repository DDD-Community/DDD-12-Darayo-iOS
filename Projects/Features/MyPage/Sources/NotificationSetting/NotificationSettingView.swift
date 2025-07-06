//
//  NotificationSettingView.swift
//  MyPage
//
//  Created by 이정원 on 7/5/25.
//  Copyright © 2025 Darayo. All rights reserved.
//

import SwiftUI
import ComposableArchitecture

public struct NotificationSettingView: View {
    let store: StoreOf<NotificationSettingFeature>

    public init(store: StoreOf<NotificationSettingFeature>) {
        self.store = store
    }

    public var body: some View {
        WithViewStore(store, observe: { $0 }) { viewStore in
            ScrollView {
                VStack(spacing: 12) {
                    ForEach(viewStore.festivals) { festival in
                        FestivalNotificationCellView(
                            festival: festival,
                            toggleAction: {
                                viewStore.send(.toggleNotification(id: festival.id, isOn: .random()))
                            }
                        )
                    }
                }
                .padding(.horizontal, 16)
                .padding(.top, 16)
            }
            .navigationTitle("알림 설정한 페스티벌 목록")
            .background(Color.background1.ignoresSafeArea())
        }
    }
}


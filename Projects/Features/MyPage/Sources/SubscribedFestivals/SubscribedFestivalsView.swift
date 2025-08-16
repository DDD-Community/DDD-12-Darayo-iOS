//
//  SubscribedFestivalsView.swift
//  MyPage
//
//  Created by 이정원 on 7/5/25.
//  Copyright © 2025 Darayo. All rights reserved.
//

import SwiftUI
import ComposableArchitecture
import DesignSystem
import Base

public struct SubscribedFestivalsView: View {
    @Bindable private var store: StoreOf<SubscribedFestivalsFeature>
    @Environment(\.openURL) private var openURL
    @Environment(\.scenePhase) private var scenePhase
    
    public init(store: StoreOf<SubscribedFestivalsFeature>) {
        self.store = store
    }
    
    public var body: some View {
        FestivalListView(
            type: .subscribed,
            festivals: store.festivals,
            isOn: store.isEnabled,
            isLoading: store.isLoading
        ) { festival in
            store.send(.festivalTapped(festival))
        } iconAction: { festival in
            store.send(.noticiationButtonTapped(festival))
        }
        .navigation(title: "알림 설정한 페스티벌 목록") {
            store.send(.backButtonTapped)
        }
        .customAlert($store.scope(state: \.alert, action: \.alert), icon: alertIcon)
        .background(Color.background1)
        .onAppear { store.send(.onAppear) }
        .refreshable { store.send(.onAppear) }
        .onChange(of: store.shouldOpenURL) { oldValue, newValue in
            guard !oldValue, newValue else { return }
            store.send(.binding(.set(\.shouldOpenURL, false)))
            guard let url = URL(string: UIApplication.openSettingsURLString) else { return }
            openURL(url)
        }
    }
}

private extension SubscribedFestivalsView {
    var alertIcon: Image? {
        return switch store.alert?.alertCase {
        case .authorization: .iconBellGray
        case .none: nil
        }
    }
}

private extension SubscribedFestivalsFeature.AlertCase {
    var title: String {
        switch self {
        case .authorization: "알림 권한이 없어요!"
        }
    }
    
    var message: String {
        "페스티벌 정보를 받으려면\n알림 권한을 허용해주세요"
    }
    
    var buttonTitle: String {
        "권한 설정하기"
    }
}

extension CustomAlert.State {
    init(alertCase: SubscribedFestivalsFeature.AlertCase) {
        self = .init(
            title: alertCase.title,
            message: alertCase.message,
            buttonTitle: alertCase.buttonTitle
        )
    }
    
    var alertCase: SubscribedFestivalsFeature.AlertCase? {
        return SubscribedFestivalsFeature.AlertCase.allCases.first {
            self == .init(alertCase: $0)
        }
    }
}

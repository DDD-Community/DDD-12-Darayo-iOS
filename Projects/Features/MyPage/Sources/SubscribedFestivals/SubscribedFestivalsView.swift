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
import Domain

public struct SubscribedFestivalsView: View {
    @Bindable private var store: StoreOf<SubscribedFestivalsFeature>
    @Environment(\.scenePhase) private var scenePhase
    @Environment(\.openURL) private var openURL
    
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
        .background(Color.background1)
        .customAlert($store.scope(state: \.alert, action: \.alert))
        .onAppear { store.send(.onAppear) }
        .refreshable { store.send(.onAppear) }
        .onChange(of: scenePhase) { oldValue, _ in
            guard oldValue == .background else { return }
            store.send(.foregroundEntered)
        }
        .onChange(of: store.shouldOpenURL) { oldValue, newValue in
            guard !oldValue, newValue else { return }
            store.send(.binding(.set(\.shouldOpenURL, false)))
            guard let url = URL(string: UIApplication.openSettingsURLString) else { return }
            openURL(url)
        }
    }
}

extension SubscribedFestivalsFeature.AlertCase: AlertPresentable {
    public var alertInfo: AlertInfo {
        switch self {
        case .authorization: return .authorization
        case .agreement: return .agreement
        case .failedToFetch(let error): return alertInfo(error)
        case .failedToUpdate(let error): return alertInfo(error)
        }
    }
    
    private func alertInfo(_ error: NetworkError) -> AlertInfo {
        switch error.type {
        case .noInternet: .noInternet
        default: .error(error, buttonTitle: "확인")
        }
    }
}

//
//  NotificationSettingFeature.swift
//  MyPage
//
//  Created by 이정원 on 7/5/25.
//  Copyright © 2025 Darayo. All rights reserved.
//
import Foundation
import ComposableArchitecture
import Domain

@Reducer
public struct NotificationSettingFeature {
    @Dependency(\.dismiss) private var dismiss
    @Dependency(\.notificationUseCase) private var notificationUseCase
    
    @ObservableState
    public struct State: Equatable {
        var festivals: [Festival] = []
        var isLoading: Bool = true
        public init() {}
    }
    
    public enum Action {
        case onAppear
        case festivalsFestched([Festival])
        case noticiationButtonTapped(Festival)
        case showAlert
        case backButtonTapped
    }
    
    public init() {}
    
    public var body: some ReducerOf<Self> {
        Reduce { state, action in
            switch action {
            case .onAppear:
                return .run { send in
                    await send(fetchSubsribedFestivals())
                }
            case .festivalsFestched(let festivals):
                state.festivals = festivals
                state.isLoading = false
                return .none
            case .noticiationButtonTapped(let festival):
                return .none
            case .showAlert:
                return .none
            case .backButtonTapped:
                return .run { _ in await self.dismiss() }
            }
        }
    }
}

private extension NotificationSettingFeature {
    func fetchSubsribedFestivals() async -> Action {
        do {
            let festivals = try await notificationUseCase.fetchSubscribedFestivals()
            return .festivalsFestched(festivals)
        } catch {
            return .showAlert
        }
    }
}

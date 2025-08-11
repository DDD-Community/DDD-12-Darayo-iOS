//
//  SubscribedFestivalsFeature.swift
//  MyPage
//
//  Created by 이정원 on 7/5/25.
//  Copyright © 2025 Darayo. All rights reserved.
//
import Foundation
import ComposableArchitecture
import Domain

@Reducer
public struct SubscribedFestivalsFeature {
    @Dependency(\.dismiss) private var dismiss
    @Dependency(\.festivalUseCase) private var festivalUseCase
    @Dependency(\.notificationUseCase) private var notificationUseCase
    
    @ObservableState
    public struct State: Equatable {
        var festivals: [Festival] = []
        var isLoading: Bool = true
        public init() {}
    }
    
    public enum Action {
        case onAppear
        case festivalsFetched([Festival])
        case unsubscribed(Int)
        case festivalTapped(Festival)
        case noticiationButtonTapped(Festival)
        case showAlert
        case backButtonTapped
        case navigateToFestival(Festival, Bool)
    }
    
    public init() {}
    
    public var body: some ReducerOf<Self> {
        Reduce { state, action in
            switch action {
            case .onAppear:
                return .run { send in
                    await send(fetchSubsribedFestivals())
                }
            case .festivalsFetched(let festivals):
                state.festivals = festivals
                state.isLoading = false
                return .none
            case .festivalTapped(let festival):
                let likedFestivals = fetchLikedFestivals()
                let isFavorite = likedFestivals.contains(festival.id)
                return .send(.navigateToFestival(festival, isFavorite))
            case .noticiationButtonTapped(let festival):
                let id = festival.id
                return .run { send in
                    await send(unsubscribe(id: id))
                }
            case .unsubscribed(let id):
                state.festivals.removeAll { $0.id == id }
                return .none
            case .showAlert:
                state.isLoading = false
                return .none
            case .backButtonTapped:
                return .run { _ in await self.dismiss() }
            case .navigateToFestival:
                return .none
            }
        }
    }
}

private extension SubscribedFestivalsFeature {
    func fetchSubsribedFestivals() async -> Action {
        do {
            let festivals = try await notificationUseCase.fetchSubscribedFestivals()
            return .festivalsFetched(festivals)
        } catch {
            return .showAlert
        }
    }
    
    func unsubscribe(id: Int) async -> Action {
        try? await notificationUseCase.updateNotification(id: id, isEnabled: false)
        return .unsubscribed(id)
    }
    
    func fetchLikedFestivals() -> Set<Int> {
        let likedFestivals = try? festivalUseCase.fetchLikedFestivals()
        return Set(likedFestivals?.map { $0.id } ?? [])
    }
}

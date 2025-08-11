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
        var isEnabled: [Bool] = []
        var isLoading: Bool = true
        public init() {}
    }
    
    public enum Action {
        case onAppear
        case festivalsFetched([Festival])
        case festivalTapped(Festival)
        case noticiationButtonTapped(Festival)
        case notificationUpdated(Int)
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
                state.isEnabled = festivals.map { _ in true }
                state.isLoading = false
                return .none
            case .festivalTapped(let festival):
                let likedFestivals = fetchLikedFestivals()
                let isFavorite = likedFestivals.contains(festival.id)
                return .send(.navigateToFestival(festival, isFavorite))
            case .noticiationButtonTapped(let festival):
                let index = state.festivals.firstIndex { $0 == festival }
                guard let index else { return .none }
                let isEnabled = state.isEnabled[index]
                return .run { send in
                    await send(updateNotificaion(festival.id, isEnabled: isEnabled))
                }
            case .notificationUpdated(let id):
                let index = state.festivals.firstIndex { $0.id == id }
                guard let index else { return .none }
                state.isEnabled[index].toggle()
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
    
    func updateNotificaion(_ id: Int, isEnabled: Bool) async -> Action {
        do {
            try await notificationUseCase.updateNotification(id: id, isEnabled: !isEnabled)
            return .notificationUpdated(id)
        } catch {
            return .showAlert
        }
    }
    
    func fetchLikedFestivals() -> Set<Int> {
        let likedFestivals = try? festivalUseCase.fetchLikedFestivals()
        return Set(likedFestivals?.map { $0.id } ?? [])
    }
}

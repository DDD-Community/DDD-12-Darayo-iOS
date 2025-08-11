//
//  LikedFestivalsFeature.swift
//  MyPage
//
//  Created by 이정원 on 8/11/25.
//  Copyright © 2025 Darayo. All rights reserved.
//

import SwiftUI
import ComposableArchitecture
import Domain

@Reducer
public struct LikedFestivalsFeature {
    @Dependency(\.dismiss) private var dismiss
    @Dependency(\.festivalUseCase) private var festivalUseCase
    
    @ObservableState
    public struct State {
        var festivals: [Festival] = []
        var isLoading: Bool = true
        public init() {}
    }
    
    public enum Action {
        case onAppear
        case festivalsFetched([Festival])
        case showAlert
        case backButtonTapped
        case festivalTapped(Festival)
        case navigateToFestival(Festival, Bool)
    }
    
    public init() {}
    public var body: some ReducerOf<Self> {
        Reduce { state, action in
            switch action {
            case .onAppear:
                state.isLoading = true
                return .run { send in
                    await send(fetchLikedFestivals())
                }
            case .festivalsFetched(let festivals):
                state.festivals = festivals
                state.isLoading = false
                return .none
            case .festivalTapped(let festival):
                do {
                    let isFavorite = try festivalUseCase.isFavorite(festival)
                    return .send(.navigateToFestival(festival, isFavorite))
                } catch {
                    return .send(.showAlert)
                }
            case .showAlert:
                state.isLoading = false
                return .none
            case .backButtonTapped:
                return .run { _ in await self.dismiss() }
            case .navigateToFestival: return .none
            }
        }
    }
}

private extension LikedFestivalsFeature {
    func fetchLikedFestivals() async -> Action {
        do {
            let ids = try Set(festivalUseCase.fetchLikedFestivals().map { $0.id })
            let festivals = try await festivalUseCase.fetchFestivals()
            let likedFestivals = festivals.filter { ids.contains($0.id) }
            return .festivalsFetched(likedFestivals)
        } catch {
            return .showAlert
        }
    }
}

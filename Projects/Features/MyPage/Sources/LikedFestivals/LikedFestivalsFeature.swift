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
import Base

@Reducer
public struct LikedFestivalsFeature {
    @Dependency(\.dismiss) private var dismiss
    @Dependency(\.festivalUseCase) private var festivalUseCase
    
    public enum AlertCase {
        case error
    }
    
    @ObservableState
    public struct State {
        var festivals: [Festival] = []
        var isFavorite: [Bool] = []
        var isLoading: Bool = true
        @Presents var alert: CustomAlert<AlertCase>.State?
        public init() {}
    }
    
    public enum Action {
        case onAppear
        case festivalsFetched([Festival])
        case showAlert(AlertCase)
        case backButtonTapped
        case festivalTapped(Festival)
        case likeButtonTapped(Festival)
        case navigateToFestival(Festival, Bool)
        case alert(PresentationAction<CustomAlert<AlertCase>.Action>)
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
                state.isFavorite = festivals.map { _ in true }
                state.isLoading = false
                return .none
            case .festivalTapped(let festival):
                do {
                    let isFavorite = try festivalUseCase.isFavorite(festival)
                    return .send(.navigateToFestival(festival, isFavorite))
                } catch {
                    return .none
                }
            case .likeButtonTapped(let festival):
                let index = state.festivals.firstIndex { $0 == festival }
                guard let index else { return .none }
                let isFavorite = state.isFavorite[index]
                updateLikedFestivals(festival.id, isFavorite: isFavorite)
                state.isFavorite[index].toggle()
                return .none
            case .showAlert(let alertCase):
                state.isLoading = false
                state.alert = .init(alertCase)
                return .none
            case .backButtonTapped:
                return .run { _ in await self.dismiss() }
            case .navigateToFestival: return .none
            case .alert: return .none
            }
        }
        .ifLet(\.$alert, action: \.alert) {
            CustomAlert()
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
            return .showAlert(.error)
        }
    }
    
    func updateLikedFestivals(_ id: Int, isFavorite: Bool) {
        switch isFavorite {
        case true: try? festivalUseCase.deleteLikedFestival(id: id)
        case false: try? festivalUseCase.addLikedFestival(id: id)
        }
    }
}

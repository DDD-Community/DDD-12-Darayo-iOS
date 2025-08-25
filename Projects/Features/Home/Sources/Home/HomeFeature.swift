//
//  HomeFeature.swift
//  Home
//
//  Created by 이정원 on 6/22/25.
//  Copyright © 2025 Darayo. All rights reserved.
//

import Foundation
import ComposableArchitecture
import Base
import Domain
import UserNotifications

@Reducer
public struct HomeFeature {
    @Dependency(\.festivalUseCase) private var festivalUseCase
    @Dependency(\.notificationUseCase) private var notificationUseCase
    
    public enum AlertCase: Equatable {
        case error(NetworkError.ErrorType)
    }
    
    @ObservableState
    public struct State {
        var allFestivals: [Festival] = []
        var likedFestivals: Set<Int> = .init()
        var selectedDate: Date?
        var isLoading: Bool = true
        
        public init() {}
        
        var festivals: [Festival] {
            allFestivals
        }
        
        var favoriteFestivals: [Festival] {
            allFestivals.filter { festival in
                likedFestivals.contains(festival.id)
            }
        }
        
        var isFavorite: [Bool] {
            festivals.map { festival in
                likedFestivals.contains(festival.id)
            }
        }
    }
    
    public enum Action {
        case onAppear
        case onRefresh
        case festivalsFetched([Festival])
        case festivalTapped(Festival)
        case heartButtonTapped(Festival)
        case myPageButtonTapped
        case showError(NetworkError?)
        case showAlert(AlertCase)
        case alert(AlertCase)
        case navigateToFestival(Festival, Bool)
    }
    
    public init() {}
    public var body: some ReducerOf<Self> {
        Reduce { state, action in
            switch action {
            case .onAppear:
                state.likedFestivals = fetchLikedFestivals()
                guard state.isLoading else { return .none }
                return .run { send in await send(fetchFestivals()) }
            case .onRefresh:
                state.isLoading = true
                return .run { send in await send(fetchFestivals()) }
            case .festivalsFetched(let festivals):
                state.allFestivals = festivals
                state.isLoading = false
                return .none
            case .festivalTapped(let festival):
                let isFavorite = state.likedFestivals.contains(festival.id)
                return .send(.navigateToFestival(festival, isFavorite))
            case .heartButtonTapped(let festival):
                updateLikedFestivals(state, id: festival.id)
                state.likedFestivals = fetchLikedFestivals()
                return .none
            case .myPageButtonTapped: return .none
            case .showError(let networkError):
                guard let networkError else { return .none }
                return .send(.showAlert(.error(networkError.type)))
            case .showAlert:
                state.isLoading = false
                return .none
            case .alert: return .none
            case .navigateToFestival: return .none
            }
        }
    }
}

private extension HomeFeature {
    func fetchFestivals() async -> Action {
        do {
            let festivals = try await festivalUseCase.fetchFestivals()
            return .festivalsFetched(festivals)
        } catch(let error) {
            let networkError = error as? NetworkError
            return .showError(networkError)
        }
    }
    
    func fetchLikedFestivals() -> Set<Int> {
        let likedFestivals = try? festivalUseCase.fetchLikedFestivals()
        return Set(likedFestivals?.map { $0.id } ?? [])
    }
    
    func updateLikedFestivals(_ state: State, id: Int) {
        let isFavorite = state.likedFestivals.contains(id)
        switch isFavorite {
        case true: try? festivalUseCase.deleteLikedFestival(id: id)
        case false: try? festivalUseCase.addLikedFestival(id: id)
        }
    }
}

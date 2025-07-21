//
//  HomeFeature.swift
//  Home
//
//  Created by 이정원 on 6/22/25.
//  Copyright © 2025 Darayo. All rights reserved.
//

import Foundation
import ComposableArchitecture
import Domain

@Reducer
public struct HomeFeature {
    @Dependency(\.festivalUseCase) private var festivalUseCase
    
    enum DisplayMode {
        case grid
        case calendar
    }
    
    @ObservableState
    public struct State {
        var displayMode: DisplayMode = .grid
        var isFiltered: Bool = false
        var allFestivals: [Festival] = []
        var likedFestivals: Set<Int> = .init()
        var selectedDate: Date?
        var isLoading: Bool = true
        
        public init() {}
        
        var festivals: [Festival] {
            switch isFiltered {
            case true: favoriteFestivals
            case false: allFestivals
            }
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
    
    public enum Action: BindableAction {
        case onAppear
        case onRefresh
        case festivalsFetched([Festival], [LikedFestival])
        case festivalTapped(Festival)
        case heartButtonTapped(Festival)
        case dateSelected(Date)
        case likedFestivalsUpdated([LikedFestival])
        case showAlert
        case binding(BindingAction<State>)
    }
    
    public init() {}
    public var body: some ReducerOf<Self> {
        BindingReducer()
        
        Reduce { state, action in
            switch action {
            case .onAppear:
                guard state.isLoading else { return .none }
                return .run { send in await send(fetchFestivals()) }
            case .onRefresh:
                state.isLoading = true
                return .run { send in await send(fetchFestivals()) }
            case .festivalsFetched(let festivals, let likedFestivals):
                state.allFestivals = festivals
                state.likedFestivals = Set(likedFestivals.map { $0.id })
                state.isLoading = false
                return .none
            case .heartButtonTapped(let festival):
                let id = festival.id
                let isLiked = !state.likedFestivals.contains(id)
                return .run { send in
                    await send(updateLikedFestivals(id: id, isLiked: isLiked))
                }
            case .dateSelected(let date):
                state.selectedDate = date
                return .none
            case .likedFestivalsUpdated(let likedFestivals):
                state.likedFestivals = Set(likedFestivals.map { $0.id })
                return .none
            case .festivalTapped: return .none
            case .showAlert: return .none
            case .binding: return .none
            }
        }
    }
}

private extension HomeFeature {
    func fetchFestivals() async -> Action {
        do {
            async let likedFestivals = festivalUseCase.fetchLikedFestivals()
            async let festivals =  festivalUseCase.fetchFestivals()
            return try await .festivalsFetched(festivals, likedFestivals)
        } catch {
            return .showAlert
        }
    }
    
    func updateLikedFestivals(id: Int, isLiked: Bool) async -> Action {
        do {
            switch isLiked {
            case true: try await festivalUseCase.addLikedFestival(id: id)
            case false: try await festivalUseCase.deleteLikedFestival(id: id)
            }
            let likedFestivals = try await festivalUseCase.fetchLikedFestivals()
            return .likedFestivalsUpdated(likedFestivals)
        } catch {
            return .showAlert
        }
    }
}

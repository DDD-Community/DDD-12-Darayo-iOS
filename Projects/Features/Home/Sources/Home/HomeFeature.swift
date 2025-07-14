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
        var favorites: Set<Festival> = .init()
        var selectedDate: Date?
        
        public init() {}
        
        var festivals: [Festival] {
            switch isFiltered {
            case true: allFestivals.filter { favorites.contains($0) }
            case false: allFestivals
            }
        }
        
        var isFavorite: [Bool] {
            festivals.map { favorites.contains($0) }
        }
    }
    
    public enum Action: BindableAction {
        case onAppear
        case festivalsFetched([Festival])
        case festivalTapped(Festival)
        case heartButtonTapped(Festival)
        case dateSelected(Date)
        case showAlert
        case binding(BindingAction<State>)
    }
    
    public init() {}
    public var body: some ReducerOf<Self> {
        BindingReducer()
        
        Reduce { state, action in
            switch action {
            case .onAppear:
                return .run { send in
                    await send(fetchFestivals())
                }
            case .festivalsFetched(let festivals):
                state.allFestivals = festivals
                return .none
            case .festivalTapped: return .none
            case .heartButtonTapped(let festival):
                if state.favorites.contains(festival) {
                    state.favorites.remove(festival)
                } else {
                    state.favorites.insert(festival)
                }
                return .none
            case .dateSelected(let date):
                state.selectedDate = date
                return .none
            case .showAlert: return .none
            case .binding: return .none
            }
        }
    }
}

private extension HomeFeature {
    func fetchFestivals() async -> Action {
        do {
            let festivals = try await festivalUseCase.fetchFestivals()
            return .festivalsFetched(festivals)
        } catch {
            return .showAlert
        }
    }
}

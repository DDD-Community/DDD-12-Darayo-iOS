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
import UserNotifications

@Reducer
public struct HomeFeature {
    @Dependency(\.festivalUseCase) private var festivalUseCase
    @Dependency(\.notificationUseCase) private var notificationUseCase
    
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
        case festivalsFetched([Festival])
        case festivalTapped(Festival)
        case heartButtonTapped(Festival)
        case dateSelected(Date)
        case showAlert
        case binding(BindingAction<State>)
        case navigateToFestival(Festival, Bool)
    }
    
    public init() {}
    public var body: some ReducerOf<Self> {
        BindingReducer()
        
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
                return .run { [state] send in
                    await updateNotificaion(state, send, id: festival.id)
                }
            case .dateSelected(let date):
                state.selectedDate = date
                return .none
            case .showAlert: return .none
            case .binding: return .none
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
        } catch {
            return .showAlert
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
    
    func updateNotificaion(_ state: State, _ send: Send<Action>, id: Int) async {
        let isAuthorized = await isAuthorized
        let isEnabled = state.likedFestivals.contains(id)
        
        guard isAuthorized || !isEnabled else { return }
        try? await notificationUseCase.updateNotification(id: id, isEnabled: isEnabled)
    }
    
    var isAuthorized: Bool {
        get async {
            let center =  UNUserNotificationCenter.current()
            let status = await center.notificationSettings().authorizationStatus
            return status == .authorized
        }
    }
}

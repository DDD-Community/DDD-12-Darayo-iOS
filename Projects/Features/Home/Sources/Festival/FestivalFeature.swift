//
//  FestivalFeature.swift
//  Home
//
//  Created by 이정원 on 6/29/25.
//  Copyright © 2025 Darayo. All rights reserved.
//

import ComposableArchitecture
import Domain
import Util
import UserNotifications
import Base

@Reducer
public struct FestivalFeature {
    public enum AlertCase: CaseIterable {
        case authorization
        case error
    }
    
    @Dependency(\.dismiss) private var dismiss
    @Dependency(\.festivalUseCase) private var festivalUseCase
    @Dependency(\.notificationUseCase) private var notificationUseCase
    
    @ObservableState
    public struct State {
        let festival: Festival
        var isAuthorized: Bool = false
        var isNotificationOn: Bool = false
        var isFavorite: Bool = false
        var isExpanded: Bool = false
        
        var shouldOpenURL: Bool = false
        
        public init(festival: Festival, isFavorite: Bool) {
            self.festival = festival
            self.isFavorite = isFavorite
        }
        
        var dateString: String {
            let dateFormat = DateFormat.festivalWithWeekday
            let startDate = festival.startDate?.toString(dateFormat: dateFormat) ?? ""
            let endDate = festival.endDate?.toString(dateFormat: dateFormat) ?? ""
            return "\(startDate) - \(endDate)"
        }
        
        var purchaseDates: [String] {
            festival.purchaseDates.map { dates in
                let dateFormat = DateFormat.reservationWithWeekday
                let open = dates[0].toString(dateFormat: dateFormat)
                let close = dates[1].toString(dateFormat: dateFormat)
                if open == close { return "\(open)" }
                else if dates[1] == .distantFuture.startOfDay { return "\(open) - " }
                else { return "\(open) - \(close)" }
            }
        }
    }
    
    public enum Action: BindableAction {
        case onAppear
        case enteredForeground
        case authorizationChecked(Bool)
        case notificationStateFetched(Bool)
        case backButtonTapped
        case notificationButtonTapped
        case heartButtonTapped
        case updateNotification(Bool)
        case seeAllButtonTapped
        case showAlert(AlertCase)
        case alert(AlertCase)
        case notificationUpdated(Bool)
        case navigateToArtistList([Artist])
        case binding(BindingAction<State>)
    }
    
    public init() {}
    public var body: some ReducerOf<Self> {
        BindingReducer()
        
        Reduce { state, action in
            switch action {
            case .onAppear, .enteredForeground:
                return .run { [state] send in
                    await fetchAll(state, send)
                }
            case .authorizationChecked(let isAuthorized):
                state.isAuthorized = isAuthorized
                return .none
            case .notificationStateFetched(let isEnabled):
                state.isNotificationOn = isEnabled
                return .none
            case .backButtonTapped:
                return .run { _ in await dismiss() }
            case .notificationButtonTapped:
                let isEnabled = !state.isNotificationOn
                
                if !state.isAuthorized, isEnabled {
                    return .send(.showAlert(.authorization))
                }
                return .send(.updateNotification(isEnabled))
            case .heartButtonTapped:
                updateLikedFestivals(state)
                state.isFavorite = checkIsFavorite(state)
                return .none
            case .updateNotification(let isEnabled):
                return .run { [state] send in
                    await send(updateNotificaion(state, isEnabled: isEnabled))
                }
            case .seeAllButtonTapped:
                let artists = state.festival.artists
                return .send(.navigateToArtistList(artists))
            case .notificationUpdated(let isEnabled):
                state.isNotificationOn = isEnabled
                return .none
            case .showAlert:
                return .none
            case .alert:
                return .none
            case .navigateToArtistList: return .none
            case .binding: return .none
            }
        }
    }
}

private extension FestivalFeature {
    func fetchAll(_ state: State, _ send: Send<Action>) async {
        do {
            let isAuthroized = await isAuthorized
            async let isEnabled = fetchNotificationState(id: state.festival.id)
            
            await send(.authorizationChecked(isAuthroized))
            try await send(.notificationStateFetched(isEnabled))
        } catch {
        }
    }
    
    var isAuthorized: Bool {
        get async {
            let center =  UNUserNotificationCenter.current()
            let status = await center.notificationSettings().authorizationStatus
            return status == .authorized
        }
    }
    
    func checkIsFavorite(_ state: State) -> Bool {
        let likedFestivals = (try? festivalUseCase.fetchLikedFestivals()) ?? []
        return likedFestivals.contains { $0.id == state.festival.id }
    }
    
    func updateLikedFestivals(_ state: State) {
        let id = state.festival.id
        let isFavorite = state.isFavorite
        switch isFavorite {
        case true: try? festivalUseCase.deleteLikedFestival(id: id)
        case false: try? festivalUseCase.addLikedFestival(id: id)
        }
    }
    
    func fetchNotificationState(id: Int) async throws -> Bool {
        let festivalID = String(id)
        return try await notificationUseCase.fetchNotificationState(id: festivalID)
    }
    
    func updateNotificaion(_ state: State, isEnabled: Bool) async -> Action {
        do {
            let id = state.festival.id
            try await notificationUseCase.updateNotification(id: id, isEnabled: isEnabled)
            return .notificationUpdated(isEnabled)
        } catch {
            return .showAlert(.error)
        }
    }
}

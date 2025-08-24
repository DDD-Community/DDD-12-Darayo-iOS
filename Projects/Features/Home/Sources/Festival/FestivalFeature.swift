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
    public enum AlertCase {
        case authorization
        case agreement
        case error
    }
    
    @Dependency(\.dismiss) private var dismiss
    @Dependency(\.festivalUseCase) private var festivalUseCase
    @Dependency(\.notificationUseCase) private var notificationUseCase
    
    @ObservableState
    public struct State {
        let festival: Festival
        var isAuthorized: Bool = false
        var isAccepted: Bool = false
        var isNotificationOn: Bool = false
        var isFavorite: Bool = false
        var isExpanded: Bool = false
        var shouldOpenURL: Bool = false
        var hasTappedButton: Bool = false
        @Presents var alert: CustomAlert<AlertCase>.State?
        
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
        case foregroundEntered
        case authorizationChecked(Bool)
        case notificationStateFetched(Bool)
        case notificationAgreementStateFetched(Bool)
        case backButtonTapped
        case notificationButtonTapped
        case heartButtonTapped
        case updateNotificationAgreement(Bool)
        case updateNotification(Bool)
        case seeAllButtonTapped
        case showAlert(AlertCase)
        case notificationUpdated(Bool)
        case notificationAgreementUpdated(Bool)
        case navigateToArtistList([Artist])
        case navigateToMyPage
        case binding(BindingAction<State>)
        case alert(PresentationAction<CustomAlert<AlertCase>.Action>)
    }
    
    public init() {}
    public var body: some ReducerOf<Self> {
        BindingReducer()
        
        Reduce { state, action in
            switch action {
            case .onAppear:
                return .run { [state] send in await fetchAll(state, send) }
            case .foregroundEntered:
                return .run { send in await checkAuthorization(send) }
            case .authorizationChecked(let isAuthorized):
                state.isAuthorized = isAuthorized
                
                switch isAuthorized {
                case true:
                    if state.isAccepted { return .none }
                    guard state.hasTappedButton else { return .none }
                    state.hasTappedButton = false
                    return .send(.updateNotificationAgreement(true))
                case false:
                    if !state.isAccepted { return .none }
                    return .send(.updateNotificationAgreement(false))
                }
            case .updateNotificationAgreement(let isEnabled):
                return .run { send in
                    await updateNotification(send, isEnabled: isEnabled)
                }
            case .notificationStateFetched(let isEnabled):
                state.isNotificationOn = isEnabled
                return .none
            case .notificationAgreementStateFetched(let isAccepted):
                state.isAccepted = isAccepted
                return .none
            case .backButtonTapped:
                return .run { _ in await dismiss() }
            case .notificationButtonTapped:
                let isEnabled = !state.isNotificationOn
                if !isEnabled {
                    return .send(.updateNotification(isEnabled))
                }
                
                if !state.isAuthorized {
                    return .send(.showAlert(.authorization))
                } else if !state.isAccepted {
                    return .send(.showAlert(.agreement))
                } else {
                    return .send(.updateNotification(isEnabled))
                }
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
            case .notificationAgreementUpdated(let isAccepted):
                state.isAccepted = isAccepted
                return .none
            case .showAlert(let alertCase):
                state.alert = .init(alertCase)
                return .none
            case .alert(.presented(.buttonTapped(.authorization))):
                state.hasTappedButton = true
                state.shouldOpenURL = true
                return .none
            case .alert(.presented(.buttonTapped(.agreement))):
                return .send(.navigateToMyPage)
            case .alert: return .none
            case .navigateToArtistList: return .none
            case .navigateToMyPage: return .none
            case .binding: return .none
            }
        }
        .ifLet(\.$alert, action: \.alert) {
            CustomAlert()
        }
    }
}

private extension FestivalFeature {
    func fetchAll(_ state: State, _ send: Send<Action>) async {
        do {
            async let isEnabled = fetchNotificationState(state)
            async let isAccepted = fetchNotificationState()
            
            try await send(.notificationStateFetched(isEnabled))
            try await send(.notificationAgreementStateFetched(isAccepted))
            await send(.authorizationChecked(isAuthorized))
        } catch {
            await send(.showAlert(.error))
        }
    }
    
    func checkAuthorization(_ send: Send<Action>) async {
        await send(.authorizationChecked(isAuthorized))
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
    
    func fetchNotificationState(_ state: State) async throws -> Bool {
        let festivalID = String(state.festival.id)
        return try await notificationUseCase.fetchNotificationState(id: festivalID)
    }
    
    func fetchNotificationState() async throws -> Bool {
        return try await notificationUseCase.fetchNotificationState()
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
    
    func updateNotification(_ send: Send<Action>, isEnabled: Bool) async {
        do {
            try await notificationUseCase.updateNotification(isEnabled: isEnabled)
            await send(.notificationAgreementUpdated(isEnabled))
        } catch {
            await send(.showAlert(.error))
        }
    }
}

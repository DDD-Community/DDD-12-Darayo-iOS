//
//  SubscribedFestivalsFeature.swift
//  MyPage
//
//  Created by 이정원 on 7/5/25.
//  Copyright © 2025 Darayo. All rights reserved.
//
import Foundation
import ComposableArchitecture
import UserNotifications
import Base
import Domain

@Reducer
public struct SubscribedFestivalsFeature {
    @Dependency(\.dismiss) private var dismiss
    @Dependency(\.festivalUseCase) private var festivalUseCase
    @Dependency(\.notificationUseCase) private var notificationUseCase
    
    public enum AlertCase: CaseIterable {
        case authorization
        case agreement
        case error
    }
    
    @ObservableState
    public struct State: Equatable {
        var festivals: [Festival] = []
        var isAuthorized: Bool = false
        var isAccepted: Bool = false
        var isEnabled: [Bool] = []
        var isLoading: Bool = true
        var shouldOpenURL: Bool = false
        var hasTappedButton: Bool = false
        @Presents var alert: CustomAlert<AlertCase>.State?
        public init() {}
    }
    
    public enum Action: BindableAction {
        case onAppear
        case foregroundEntered
        case authorizationChecked(Bool)
        case notificationStateFetched(Bool)
        case festivalsFetched([Festival])
        case updateNotificationAgreement(Bool)
        case festivalTapped(Festival)
        case noticiationButtonTapped(Festival)
        case notificationAgreementUpdated(Bool)
        case notificationUpdated(Int)
        case showAlert(AlertCase)
        case backButtonTapped
        case navigateToFestival(Festival, Bool)
        case binding(BindingAction<State>)
        case alert(PresentationAction<CustomAlert<AlertCase>.Action>)
    }
    
    public init() {}
    
    public var body: some ReducerOf<Self> {
        BindingReducer()
        
        Reduce { state, action in
            switch action {
            case .onAppear:
                state.isLoading = true
                return .run { send in await fetchAll(send) }
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
            case .notificationStateFetched(let isAccepted):
                state.isAccepted = isAccepted
                return .none
            case .festivalsFetched(let festivals):
                state.festivals = festivals
                state.isEnabled = festivals.map { _ in true }
                state.isLoading = false
                return .none
            case .updateNotificationAgreement(let isEnabled):
                return .run { send in
                    await updateNotification(send, isEnabled: isEnabled)
                }
            case .festivalTapped(let festival):
                let likedFestivals = fetchLikedFestivals()
                let isFavorite = likedFestivals.contains(festival.id)
                return .send(.navigateToFestival(festival, isFavorite))
            case .noticiationButtonTapped(let festival):
                let index = state.festivals.firstIndex { $0 == festival }
                guard let index else { return .none }
                let isEnabled = !state.isEnabled[index]
                
                if !isEnabled {
                    return .run { send in
                        await send(updateNotificaion(festival.id, isEnabled: isEnabled))
                    }
                }
                
                if !state.isAuthorized {
                    return .send(.showAlert(.authorization))
                } else if !state.isAccepted {
                    return .send(.showAlert(.agreement))
                } else {
                    return .run { send in
                        await send(updateNotificaion(festival.id, isEnabled: isEnabled))
                    }
                }
            case .notificationUpdated(let id):
                let index = state.festivals.firstIndex { $0.id == id }
                guard let index else { return .none }
                state.isEnabled[index].toggle()
                return .none
            case .notificationAgreementUpdated(let isAccepted):
                state.isAccepted = isAccepted
                return .none
            case .showAlert(let alertCase):
                state.isLoading = false
                state.alert = .init(alertCase)
                return .none
            case .alert(.presented(.buttonTapped(.authorization))):
                state.hasTappedButton = true
                state.shouldOpenURL = true
                return .none
            case .alert(.presented(.buttonTapped(.agreement))):
                return .send(.backButtonTapped)
            case .alert: return .none
            case .backButtonTapped:
                return .run { _ in await self.dismiss() }
            case .navigateToFestival:
                return .none
            case .binding: return .none
            }
        }
        .ifLet(\.$alert, action: \.alert) {
            CustomAlert()
        }
    }
}

private extension SubscribedFestivalsFeature {
    func checkAuthorization(_ send: Send<Action>) async {
        await send(.authorizationChecked(isAuthorized))
    }
    
    func fetchAll(_ send: Send<Action>) async {
        do {
            async let festivals = fetchSubsribedFestivals()
            async let isAccepted = fetchNotificationState()
            
            try await send(.festivalsFetched(festivals))
            try await send(.notificationStateFetched(isAccepted))
            await send(.authorizationChecked(isAuthorized))
        } catch {
            await send(.showAlert(.error))
        }
    }
    
    func fetchSubsribedFestivals() async throws -> [Festival] {
        return try await notificationUseCase.fetchSubscribedFestivals()
    }
    
    func fetchNotificationState() async throws -> Bool {
        return try await notificationUseCase.fetchNotificationState()
    }
    
    func updateNotificaion(_ id: Int, isEnabled: Bool) async -> Action {
        do {
            let isAuthorized = await isAuthorized
            if !isAuthorized, isEnabled {
                return .showAlert(.authorization)
            }
            
            try await notificationUseCase.updateNotification(id: id, isEnabled: isEnabled)
            return .notificationUpdated(id)
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
    
    func fetchLikedFestivals() -> Set<Int> {
        let likedFestivals = try? festivalUseCase.fetchLikedFestivals()
        return Set(likedFestivals?.map { $0.id } ?? [])
    }
    
    var isAuthorized: Bool {
        get async {
            let center =  UNUserNotificationCenter.current()
            let status = await center.notificationSettings().authorizationStatus
            return status == .authorized
        }
    }
}

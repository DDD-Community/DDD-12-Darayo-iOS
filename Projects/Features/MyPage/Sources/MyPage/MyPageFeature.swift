//
//  MyPageFeature.swift
//  MyPage
//
//  Created by 이정원 on 6/23/25.
//  Copyright © 2025 Darayo. All rights reserved.
//

import Foundation
import UserNotifications
import ComposableArchitecture
import Domain
import Util
import Base

@Reducer
public struct MyPageFeature {
    @Dependency(\.notificationUseCase) private var notificationUseCase
    @Dependency(\.festivalUseCase) private var festivalUseCase
    @Dependency(\.dismiss) private var dismiss
    
    public enum AlertCase: Equatable {
        case error(NetworkError)
        case authorization
    }
    
    @ObservableState
    public struct State {
        var likedFestivals: [LikedFestival] = []
        var subscribedFestivals: [Festival] = []
        var isLoading: Bool = false
        var isAuthorized: Bool = false
        var isNotificationOn: Bool = false
        
        var isLatestVersion: Bool = true
        var currentVersion: String
        var latestVersion: String
        var shouldOpenURL: Bool = false
        var hasTappedButton: Bool = false
        @Presents var alert: CustomAlert<AlertCase>.State?
        
        public init() {
            let appVersion = Bundle.appVersion
            self.currentVersion = appVersion
            self.latestVersion = appVersion
        }
    }
    
    public enum Action: BindableAction {
        case onAppear
        case enteredForeground
        case authorizationChecked(Bool)
        case notificationStateFetched(Bool)
        case likedFestivalsFetched([LikedFestival])
        case subscribedFestivalsFetched([Festival])
        case allFetched
        case toggleChanged(Bool)
        case setToggle(Bool)
        case likedFestivalsButtonTapped
        case subscribedFestivalsButtonTapped
        case showError(NetworkError?)
        case showAlert(AlertCase)
        case menuTapped(Menu)
        case backButtonTapped
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
            case .enteredForeground:
                return .run { send in await checkAuthorization(send) }
            case .authorizationChecked(let isAuthorized):
                state.isAuthorized = isAuthorized
                
                switch isAuthorized {
                case true:
                    if state.isNotificationOn { return .none }
                    guard state.hasTappedButton else { return .none }
                    state.hasTappedButton = false
                    return .run { send in
                        await send(updateNotification(isEnabled: true))
                    }
                case false:
                    if !state.isNotificationOn { return .none }
                    return .run { send in
                        await send(updateNotification(isEnabled: false))
                    }
                }
            case .notificationStateFetched(let isEnabled):
                state.isNotificationOn = isEnabled
                return .none
            case .likedFestivalsFetched(let festivals):
                state.likedFestivals = festivals
                return .none
            case .subscribedFestivalsFetched(let festivals):
                state.subscribedFestivals = festivals
                return .none
            case .allFetched:
                state.isLoading = false
                return .none
            case .toggleChanged(let isOn):
                if isOn, !state.isAuthorized {
                    return .send(.showAlert(.authorization))
                }
                
                return .run { send in
                    await send(updateNotification(isEnabled: isOn))
                }
            case .setToggle(let isOn):
                state.isNotificationOn = isOn
                return .none
            case .backButtonTapped:
                return .run { _ in await dismiss() }
            case .showError(let networkError):
                guard let networkError else { return .none }
                return .send(.showAlert(.error(networkError)))
            case .showAlert(let alertCase):
                state.alert = .init(alertCase)
                return .none
            case .alert(.presented(.buttonTapped(.authorization))):
                state.hasTappedButton = true
                state.shouldOpenURL = true
                return .none
            case .alert:
                return .none
            case .likedFestivalsButtonTapped: return .none
            case .subscribedFestivalsButtonTapped: return .none
            case .menuTapped: return .none
            case .binding: return .none
            }
        }
        .ifLet(\.$alert, action: \.alert) {
            CustomAlert()
        }
    }
}

private extension MyPageFeature {
    func fetchAll(_ send: Send<Action>) async {
        do {
            let likedFestivals = try festivalUseCase.fetchLikedFestivals()
            async let subscribedFestivals = notificationUseCase.fetchSubscribedFestivals()
            async let isEnabled = fetchNotificationState()
            
            await send(.likedFestivalsFetched(likedFestivals))
            try await send(.subscribedFestivalsFetched(subscribedFestivals))
            try await send(.notificationStateFetched(isEnabled))
            await send(.authorizationChecked(isAuthorized))
            await send(.allFetched)
        } catch {
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
    
    func fetchNotificationState() async throws -> Bool {
        return try await notificationUseCase.fetchNotificationState()
    }
    
    func updateNotification(isEnabled: Bool) async -> Action {
        do {
            try await notificationUseCase.updateNotification(isEnabled: isEnabled)
            return .setToggle(isEnabled)
        } catch {
            let networkError = error as? NetworkError
            return .showError(networkError)
        }
    }
}

extension MyPageFeature {
    public enum Menu: CaseIterable {
        case inquiry
        case termsOfService
        case privacyPolicy
    }
}

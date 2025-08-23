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
    
    public enum AlertCase {
        case error
        case authorization
    }
    
    @ObservableState
    public struct State {
        var likedFestivals: [LikedFestival] = []
        var subscribedFestivals: [Festival] = []
        
        var isAuthorized: Bool = false
        var isNotificationOn: Bool = false
        
        var isLatestVersion: Bool = true
        var currentVersion: String
        var latestVersion: String
        
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
        case checkAuthorization
        case authorizationChecked(Bool)
        case notificationStateFetched(Bool)
        case likedFestivalsFetched([LikedFestival])
        case subscribedFestivalsFetched([Festival])
        case allFetched
        case toggleChanged(Bool)
        case setToggle(Bool)
        case likedFestivalsButtonTapped
        case subscribedFestivalsButtonTapped
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
                return .merge([
                    .send(.checkAuthorization),
                    .run { send in await fetchAll(send) }
                ])
            case .enteredForeground:
                return .send(.checkAuthorization)
            case .checkAuthorization:
                return .run { send in
                    let isAuthorized = await isAuthorized
                    await send(.authorizationChecked(isAuthorized))
                }
            case .authorizationChecked(let isAuthorized):
                let isChanged = state.isAuthorized != isAuthorized
                state.isAuthorized = isAuthorized
                guard isChanged else { return .none }
                
                switch isAuthorized {
                case true:
                    return .run { send in
                        await send(fetchNotificationState())
                    }
                case false:
                    state.isNotificationOn = false
                    return .run { send in
                        await updateNotification(isEnabled: false)
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
                return .none
            case .toggleChanged(let isOn):
                return .run { send in
                    switch await isAuthorized {
                    case true:
                        await send(.setToggle(isOn))
                        await updateNotification(isEnabled: isOn)
                    case false:
                        await send(.showAlert(.authorization))
                    }
                }
            case .setToggle(let isOn):
                state.isNotificationOn = isOn
                return .none
            case .backButtonTapped:
                return .run { _ in await dismiss() }
            case .showAlert(let alertCase):
                state.alert = .init(alertCase)
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
            
            await send(.likedFestivalsFetched(likedFestivals))
            try await send(.subscribedFestivalsFetched(subscribedFestivals))
            await send(.allFetched)
        } catch {
            await send(.showAlert(.error))
        }
    }
    
    var isAuthorized: Bool {
        get async {
            let center =  UNUserNotificationCenter.current()
            let status = await center.notificationSettings().authorizationStatus
            return status == .authorized
        }
    }
    
    func fetchNotificationState() async -> Action {
        do {
            let isEnabled = try await notificationUseCase.fetchNotificationState()
            return .notificationStateFetched(isEnabled)
        } catch {
            return .showAlert(.error)
        }
    }
    
    func updateNotification(isEnabled: Bool) async {
        try? await notificationUseCase.updateNotification(isEnabled: isEnabled)
    }
}

extension MyPageFeature {
    public enum Menu: CaseIterable {
        case inquiry
        case termsOfService
        case privacyPolicy
    }
}

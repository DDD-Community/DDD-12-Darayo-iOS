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
import Util

@Reducer
public struct MyPageFeature {
    @Dependency(\.notificationUseCase) private var notificationUseCase
    @Dependency(\.dismiss) private var dismiss
    
    @ObservableState
    public struct State {
        var isAuthorized: Bool = false
        var isNotificationOn: Bool = false
        
        var isLatestVersion: Bool = true
        var currentVersion: String
        var latestVersion: String
        
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
        case toggleChanged(Bool)
        case setToggle(Bool)
        case showAlert
        case menuTapped(Menu)
        case backButtonTapped
        case binding(BindingAction<State>)
    }
    
    public init() {}
    
    public var body: some ReducerOf<Self> {
        BindingReducer()

        Reduce { state, action in
            switch action {
            case .onAppear, .enteredForeground:
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
            case .toggleChanged(let isOn):
                return .run { send in
                    switch await isAuthorized {
                    case true:
                        await send(.setToggle(isOn))
                        await updateNotification(isEnabled: isOn)
                    case false:
                        await send(.showAlert)
                    }
                }
            case .setToggle(let isOn):
                state.isNotificationOn = isOn
                return .none
            case .backButtonTapped:
                return .run { _ in await dismiss() }
            case .showAlert:
                return .none
            case .menuTapped: return .none
            case .binding: return .none
            }
        }
    }
}

private extension MyPageFeature {
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
            return .showAlert
        }
    }
    
    func updateNotification(isEnabled: Bool) async {
        try? await notificationUseCase.updateNotification(isEnabled: isEnabled)
    }
}

extension MyPageFeature {
    public enum Menu {
        case notificationSettings
        case individualNotificationSettings
        case inquiry
        case termsOfService
        case privacyPolicy
    }
}

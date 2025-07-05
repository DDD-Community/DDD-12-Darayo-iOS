//
//  MyPageFeature.swift
//  MyPage
//
//  Created by 이정원 on 6/23/25.
//  Copyright © 2025 Darayo. All rights reserved.
//

import Foundation
import ComposableArchitecture
import Util

@Reducer
public struct MyPageFeature {
    @ObservableState
    public struct State {
        var isNotificationOn: Bool = true
        var isLatestVersion: Bool = true
        var isPresentingNotificationSetting: Bool = false
        
        var currentVersion: String
        var latestVersion: String
        
        public init() {
            let appVersion = Bundle.appVersion
            self.currentVersion = appVersion
            self.latestVersion = appVersion
        }
    }
    
    public enum Action: BindableAction {
        case menuTapped(Menu)
        case binding(BindingAction<State>)
        case dismissNotificationSetting
    }
    
    public init() {}
    
    public var body: some ReducerOf<Self> {
        BindingReducer()
        
        Reduce { state, action in
            switch action {
            case .menuTapped(let menu):
                switch menu {
                case .notificationSetting:
                    state.isPresentingNotificationSetting = true
                    return .none
                case .favoritesNotification, .inquiry, .termsOfService:
                    return .none
                }
            case .dismissNotificationSetting:
                state.isPresentingNotificationSetting = false
                return .none
            case .binding:
                return .none
            }
        }
    }
}

extension MyPageFeature {
    public enum Menu {
        case favoritesNotification
        case notificationSetting
        case inquiry
        case termsOfService
        case privacyPolicy
    }
}

// MARK: - NotificationSettingFeature

@Reducer
public struct NotificationSettingFeature {
    @ObservableState
    public struct State {
        var festivals: [Festival] = Festival.dummyData
        public init() {}
    }
    
    public enum Action {
        case festivalTapped(Festival)
        case toggleNotification(Festival.ID)
        case backButtonTapped
    }
    
    public init() {}
    
    public var body: some ReducerOf<Self> {
        Reduce { state, action in
            switch action {
            case .festivalTapped:
                return .none
            case .toggleNotification(let id):
                if let index = state.festivals.firstIndex(where: { $0.id == id }) {
                    state.festivals[index].isNotificationEnabled.toggle()
                }
                return .none
            case .backButtonTapped:
                return .none
            }
        }
    }
}

// MARK: - Festival Model

public struct Festival: Identifiable, Equatable {
    public let id = UUID()
    public let name: String
    public let location: String
    public let period: String
    public var isNotificationEnabled: Bool
    
    public init(name: String, location: String, period: String, isNotificationEnabled: Bool = true) {
        self.name = name
        self.location = location
        self.period = period
        self.isNotificationEnabled = isNotificationEnabled
    }
    
    public static let dummyData: [Festival] = [
        Festival(name: "페스티벌명 최대 1줄", location: "장소 인천 송도 달빛광장", period: "25.08.01 - 25.08.03"),
        Festival(name: "페스티벌명 최대 1줄", location: "장소 인천 송도 달빛광장", period: "25.08.01 - 25.08.03"),
        Festival(name: "페스티벌명 최대 1줄", location: "장소 인천 송도 달빛광장", period: "25.08.01 - 25.08.03"),
        Festival(name: "페스티벌명 최대 1줄", location: "장소 인천 송도 달빛광장", period: "25.08.01 - 25.08.03"),
        Festival(name: "페스티벌명 최대 1줄", location: "장소 인천 송도 달빛광장", period: "25.08.01 - 25.08.03"),
        Festival(name: "페스티벌명 최대 1줄", location: "장소 인천 송도 달빛광장", period: "25.08.01 - 25.08.03"),
    ]
}

//
//  MyPageFeature.swift
//  MyPage
//
//  Created by 이정원 on 6/23/25.
//  Copyright © 2025 Darayo. All rights reserved.
//

import ComposableArchitecture
import Foundation

@Reducer
public struct MyPageFeature {
    @ObservableState
    public struct State {
        var isNotificationOn: Bool = true
        var isLatestVersion: Bool = true
        // 특정 페스티벌 알림 설정 화면(NotificationSettingView)의 present 여부를 관리
        var isPresentingNotificationSetting: Bool = false
        public init() {}
    }
    
    public enum Action: BindableAction {
        case menuTapped(Menu)
        case binding(BindingAction<State>)
        // 알림 설정 화면을 닫을 때 사용할 액션
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
        case festivalTapped(Festival) // 향후 상세 페이지 진입용
        case toggleNotification(Festival.ID) // 페스티벌 알림 토글
        case backButtonTapped // 뒤로 가기 처리용
    }
    
    public init() {}
    public var body: some ReducerOf<Self> {
        Reduce { state, action in
            switch action {
            case .festivalTapped:
                // 상세 화면으로 이동 (추후 구현)
                return .none
            case .toggleNotification(let id):
                // // 리스트에서 ID로 찾아 isNotificationEnabled를 토글
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

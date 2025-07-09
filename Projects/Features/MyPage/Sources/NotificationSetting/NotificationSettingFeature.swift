//
//  NotificationSettingFeature.swift
//  MyPage
//
//  Created by 이정원 on 7/5/25.
//  Copyright © 2025 Darayo. All rights reserved.
//
import Foundation
import ComposableArchitecture

public struct FestivalNotification: Equatable, Identifiable {
    public let id: UUID
    public let name: String
    public var isNotificationOn: Bool
}

@Reducer
public struct NotificationSettingFeature {
    
    @ObservableState
    public struct State: Equatable {
        public var festivals: [FestivalNotification] = []
        
        public init() {}
    }
    
    public enum Action {
        case onAppear
        case toggleNotification(id: UUID, isOn: Bool)
        case backButtonTapped 
    }
    
    public init() {}
    
    public var body: some ReducerOf<Self> {
        Reduce { state, action in
            switch action {
            case .onAppear:
                state.festivals = [
                        FestivalNotification(id: UUID(), name: "DDD 밴드 페스티벌", isNotificationOn: true),
                        FestivalNotification(id: UUID(), name: "한강 썸머 뮤직", isNotificationOn: false),
                        FestivalNotification(id: UUID(), name: "야외 재즈 나잇", isNotificationOn: true)
                ]
                return .none
                
            case let .toggleNotification(id, isOn):
                // 해당 id에 맞는 항목의 알림 상태 업데이트
                if let index = state.festivals.firstIndex(where: { $0.id == id }) {
                    state.festivals[index].isNotificationOn = isOn
                }
                return .none
                
            case .backButtonTapped:
                return .none
            }
        }
    }
}

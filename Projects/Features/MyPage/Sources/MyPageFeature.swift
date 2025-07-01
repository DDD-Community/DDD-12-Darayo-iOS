//
//  MyPageFeature.swift
//  MyPage
//
//  Created by 이정원 on 6/23/25.
//  Copyright © 2025 Darayo. All rights reserved.
//

import ComposableArchitecture

@Reducer
public struct MyPageFeature {
    @ObservableState
    public struct State {
        var isNotificationOn: Bool = true
        var isLatestVersion: Bool = true
        public init() {}
    }
    
    public enum Action: BindableAction {
        case menuTapped(Menu)
        case binding(BindingAction<State>)
    }
    
    public init() {}
    public var body: some ReducerOf<Self> {
        BindingReducer()
        
        Reduce { state, action in
            switch action {
            case .menuTapped: return .none
            case .binding: return .none
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

//
//  FestivalFeature.swift
//  Home
//
//  Created by 이정원 on 6/29/25.
//  Copyright © 2025 Darayo. All rights reserved.
//

import ComposableArchitecture
import Domain

@Reducer
public struct FestivalFeature {
    @ObservableState
    public struct State {
        let festival: Festival
        var isNotificationOn: Bool = false
        var isFavorite: Bool = false
        
        public init(festival: Festival) {
            self.festival = festival
        }
    }
    
    public enum Action {
        case notificationButtonTapped
        case heartButtonTapped
    }
    
    public init() {}
    public var body: some ReducerOf<Self> {
        Reduce { state, action in
            switch action {
            case .notificationButtonTapped:
                state.isNotificationOn.toggle()
                return .none
            case .heartButtonTapped:
                state.isFavorite.toggle()
                return .none
            }
        }
    }
}

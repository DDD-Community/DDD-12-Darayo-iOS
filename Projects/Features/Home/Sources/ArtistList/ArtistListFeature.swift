//
//  ArtistListFeature.swift
//  Home
//
//  Created by 이정원 on 7/2/25.
//  Copyright © 2025 Darayo. All rights reserved.
//

import ComposableArchitecture

@Reducer
public struct ArtistListFeature {
    @Dependency(\.dismiss) private var dismiss
    
    @ObservableState
    public struct State {
        var totalDays: Int = 3
        var selectedDay: Int = 1
        public init() {}
    }
    
    public enum Action {
        case backButtonTapped
        case dayButtonTapped(Int)
    }
    
    public init() {}
    public var body: some ReducerOf<Self> {
        Reduce { state, action in
            switch action {
            case .backButtonTapped:
                return .run { _ in await dismiss() }
            case .dayButtonTapped(let day):
                state.selectedDay = day
                return .none
            }
        }
    }
}

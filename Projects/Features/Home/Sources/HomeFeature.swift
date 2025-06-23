//
//  HomeFeature.swift
//  Home
//
//  Created by 이정원 on 6/22/25.
//  Copyright © 2025 Darayo. All rights reserved.
//

import ComposableArchitecture

@Reducer
public struct HomeFeature {
    @ObservableState
    public struct State {
        var displayMode: DisplayMode = .grid
        var isFiltered: Bool = false
        
        public init() {}
    }
    
    public enum Action: BindableAction {
        case binding(BindingAction<State>)
    }
    
    public init() {}
    public var body: some ReducerOf<Self> {
        BindingReducer()
        
        Reduce { state, action in
            return .none
        }
    }
}

extension HomeFeature {
    enum DisplayMode {
        case grid
        case calendar
    }
}

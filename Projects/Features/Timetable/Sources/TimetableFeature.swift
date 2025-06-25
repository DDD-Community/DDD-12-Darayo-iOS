//
//  TimetableFeature.swift
//  Timetable
//
//  Created by 이정원 on 6/23/25.
//  Copyright © 2025 Darayo. All rights reserved.
//

import ComposableArchitecture

@Reducer
public struct TimetableFeature {
    @ObservableState
    public struct State {
        var festivalName: String = "서울 재즈 페스티벌"
        var dateString: String = "25.08.08 (금)"
        public init() {}
    }
    
    public enum Action {
        
    }
    
    public init() {}
    public var body: some ReducerOf<Self> {
        Reduce { state, action in
            return .none
        }
    }
}

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
        @Presents var selectFestival: SelectFestivalFeature.State?
        public init() {}
    }
    
    public enum Action {
        case festivalButtonTapped
        case selectFestival(PresentationAction<SelectFestivalFeature.Action>)
    }
    
    public init() {}
    public var body: some ReducerOf<Self> {
        Reduce { state, action in
            switch action {
            case .festivalButtonTapped:
                state.selectFestival = .init(selectedFestival: state.festivalName)
                return .none
            case .selectFestival(.presented(.doneButtonTapped)):
                let name = state.selectFestival?.selectedFestival
                if let name { state.festivalName = name }
                return .none
            case .selectFestival: return .none
            }
            
        }
        .ifLet(\.$selectFestival, action: \.selectFestival) {
            SelectFestivalFeature()
        }
    }
}

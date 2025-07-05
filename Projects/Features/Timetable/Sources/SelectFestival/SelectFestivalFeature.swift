//
//  SelectFestivalFeature.swift
//  Timetable
//
//  Created by 이정원 on 7/4/25.
//  Copyright © 2025 Darayo. All rights reserved.
//

import ComposableArchitecture

@Reducer
public struct SelectFestivalFeature {
    @Dependency(\.dismiss) private var dismiss
    
    @ObservableState
    public struct State {
        var festivals: [String]
        var selectedFestival: String
        
        public init(selectedFestival: String) {
            self.festivals = [
                "인천 펜타포트 락 페스티벌",
                "전주 얼티밋 뮤직 페스티벌",
                "원 유니버스 페스티벌",
                "서울 재즈 페스티벌",
                "렛츠락 페스티벌",
                "Summer Sonic",
                "러브칩스 페스티벌"
            ]
            self.selectedFestival = selectedFestival
        }
    }
    
    public enum Action: BindableAction {
        case closeButtonTapped
        case doneButtonTapped
        case binding(BindingAction<State>)
    }
    
    public init() {}
    public var body: some ReducerOf<Self> {
        BindingReducer()
        
        Reduce { state, action in
            switch action {
            case .closeButtonTapped, .doneButtonTapped:
                return .run { _ in await dismiss() }
            case .binding: return .none
            }
        }
    }
}

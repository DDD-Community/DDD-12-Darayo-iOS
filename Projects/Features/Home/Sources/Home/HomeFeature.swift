//
//  HomeFeature.swift
//  Home
//
//  Created by 이정원 on 6/22/25.
//  Copyright © 2025 Darayo. All rights reserved.
//

import Foundation
import ComposableArchitecture
import Domain

@Reducer
public struct HomeFeature {
    @ObservableState
    public struct State {
        var displayMode: DisplayMode = .grid
        var isFiltered: Bool = false
        var festivals: [Festival] = [
            .init(
                title: "인천 펜타포트 락 페스티벌",
                dateString: "25.08.01-25.08.03",
                place: "인천 송도 달빛축제공원"
            ),
            .init(
                title: "전주 얼티밋 뮤직 페스티벌",
                dateString: "25.08.15-25.08.17",
                place: "전북대학교 대운동장"
            ),
            .init(
                title: "원 유니버스 페스티벌",
                dateString: "25.08.15-25.08.16",
                place: "장소미정"
            ),
            .init(
                title: "렛츠락 페스티벌",
                dateString: "25.09.06-25.09.07",
                place: "난지 한강공원"
            ),
            .init(
                title: "Summer Sonic",
                dateString: "25.08.16-25.08.17",
                place: "장소미정"
            ),
            .init(
                title: "러브칩스 페스티벌",
                dateString: "25.08.01-25.08.03",
                place: "인천 상상플랫폼 야외광장"
            ),
        ]
        
        var selectedDate: Date?
        
        public init() {}
    }
    
    public enum Action: BindableAction {
        case festivalTapped(Festival)
        case dateSelected(Date)
        case binding(BindingAction<State>)
    }
    
    public init() {}
    public var body: some ReducerOf<Self> {
        BindingReducer()
        
        Reduce { state, action in
            switch action {
            case .festivalTapped: return .none
            case .dateSelected(let date):
                state.selectedDate = date
                return .none
            case .binding: return .none
            }
        }
    }
}

extension HomeFeature {
    enum DisplayMode {
        case grid
        case calendar
    }
}

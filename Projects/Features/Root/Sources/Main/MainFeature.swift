//
//  MainFeature.swift
//  Root
//
//  Created by 이정원 on 6/21/25.
//  Copyright © 2025 Darayo. All rights reserved.
//

import ComposableArchitecture
import Home
import Timetable
import MyPage

@Reducer
public struct MainFeature {
    @ObservableState
    public struct State {
        var currentTab: Tab = .home
        var home: HomeFeature.State = .init()
        var timetable: TimetableFeature.State = .init()
        var myPage: MyPageFeature.State = .init()
    }
    
    public enum Action: BindableAction {
        case home(HomeFeature.Action)
        case timetable(TimetableFeature.Action)
        case myPage(MyPageFeature.Action)
        case binding(BindingAction<State>)
    }
    
    public init() {}
    public var body: some ReducerOf<Self> {
        BindingReducer()
        
        Scope(state: \.home, action: \.home) {
            HomeFeature()
        }
        
        Scope(state: \.timetable, action: \.timetable) {
            TimetableFeature()
        }
        
        Scope(state: \.myPage, action: \.myPage) {
            MyPageFeature()
        }
        
        Reduce { state, action in
            switch action {
            case .home: return .none
            case .timetable: return .none
            case .myPage: return .none
            case .binding: return .none
            }
        }
    }
}

extension MainFeature {
    public enum Tab: CaseIterable {
        case home
        case timetable
        case myPage
        
        var name: String {
            switch self {
            case .home: "홈"
            case .timetable: "타임테이블"
            case .myPage: "MY"
            }
        }
    }
}

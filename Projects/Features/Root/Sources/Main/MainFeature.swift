//
//  MainFeature.swift
//  Root
//
//  Created by 이정원 on 6/21/25.
//  Copyright © 2025 Darayo. All rights reserved.
//

import Foundation
import ComposableArchitecture
import Home
import Timetable
import MyPage
import Util

@Reducer
public struct MainFeature {
    @ObservableState
    public struct State {
        var currentTab: Tab = .home
        var home: HomeFeature.State = .init()
        var timetable: TimetableFeature.State = .init()
        var myPage: MyPageFeature.State = .init()
        var path: StackState<Path.State> = .init()
        var url: URL?
    }
    
    public enum Action: BindableAction {
        case home(HomeFeature.Action)
        case timetable(TimetableFeature.Action)
        case myPage(MyPageFeature.Action)
        case binding(BindingAction<State>)
        case path(StackActionOf<Path>)
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
            case let .home(.navigateToFestival(festival, isFavorite)):
                state.path.append(.festival(.init(festival: festival, isFavorite: isFavorite)))
                return .none
            case .myPage(.menuTapped(.inquiry)):
                state.url = URL(string: Constant.URL.inquiry)
                return .none
            case .myPage(.menuTapped(let menu)):
                let pathState = getPathState(menu: menu)
                guard let pathState else { return .none }
                state.path.append(pathState)
                return .none
            case .path(.element(_, .festival(.navigateToArtistList(let artists)))):
                state.path.append(.artistList(.init(artists: artists)))
                return .none
            case .home: return .none
            case .timetable: return .none
            case .myPage: return .none
            case .binding: return .none
            case .path: return .none
            }
        }
        .forEach(\.path, action: \.path)
    }
}

private extension MainFeature {
    func getPathState(menu: MyPageFeature.Menu) -> MainFeature.Path.State? {
        return switch menu {
        case .individualNotificationSettings: .notificationSetting(.init())
        case .termsOfService: .termsOfService(.init())
        case .privacyPolicy: .privacyPolicy(.init())
        case .notificationSettings: nil
        case .inquiry: nil
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
    
    @Reducer
    public enum Path {
        case festival(FestivalFeature)
        case artistList(ArtistListFeature)
        case notificationSetting(NotificationSettingFeature)
        case termsOfService(TermsOfServiceFeature)
        case privacyPolicy(PrivacyPolicyFeature)
    }
}

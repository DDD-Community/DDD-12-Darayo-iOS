//
//  MainFeature.swift
//  Root
//
//  Created by 이정원 on 6/21/25.
//  Copyright © 2025 Darayo. All rights reserved.
//

import UIKit
import ComposableArchitecture
import Home
import Timetable
import MyPage
import Util
import Base
import UserNotifications

@Reducer
public struct MainFeature {
    @ObservableState
    public struct State {
        var currentTab: Tab = .home
        var home: HomeFeature.State = .init()
        var path: StackState<Path.State> = .init()
        var url: URL?
        
        @Presents var alert: CustomAlert.State?
        var shouldOpenURL: Bool = false
    }
    
    public enum Action: BindableAction {
        case enteredForeground
        case home(HomeFeature.Action)
        case binding(BindingAction<State>)
        case path(StackActionOf<Path>)
        case alert(PresentationAction<CustomAlert.Action>)
    }
    
    public init() {}
    public var body: some ReducerOf<Self> {
        BindingReducer()
        
        Scope(state: \.home, action: \.home) {
            HomeFeature()
        }
        
        Reduce { state, action in
            switch action {
            case .enteredForeground:
                return .run { _ in await checkNotification() }
            case let .home(.navigateToFestival(festival, isFavorite)):
                state.path.append(.festival(.init(festival: festival, isFavorite: isFavorite)))
                return .none
            case .home(.myPageButtonTapped):
                state.path.append(.myPage(.init()))
                return .none
            case .alert(.presented(.buttonTapped)):
                state.shouldOpenURL = true
                return .none
            case .path(.element(_, .myPage(.showAlert))):
                state.alert = .authorization
                return .none
            case .path(.element(_, .myPage(.likedFestivalsButtonTapped))):
                state.path.append(.likedFestivals(.init()))
                return .none
            case .path(.element(_, .myPage(.subscribedFestivalsButtonTapped))):
                state.path.append(.subscribedFestivals(.init()))
                return .none
            case .path(.element(_, .myPage(.menuTapped(.inquiry)))):
                state.url = URL(string: Constant.URL.inquiry)
                return .none
            case .path(.element(_, .myPage(.menuTapped(let menu)))):
                let pathState = getPathState(menu: menu)
                guard let pathState else { return .none }
                state.path.append(pathState)
                return .none
            case .path(.element(_, .festival(.navigateToArtistList(let artists)))):
                state.path.append(.artistList(.init(artists: artists)))
                return .none
            case .path(.element(_, .likedFestivals(let action))):
                switch action {
                case .navigateToFestival(let festival, let isFavorite):
                    state.path.append(.festival(.init(
                        festival: festival, isFavorite: isFavorite
                    )))
                    return .none
                default: return .none
                }
            case .path(.element(_, .subscribedFestivals(let action))):
                switch action {
                case .navigateToFestival(let festival, let isFavorite):
                    state.path.append(.festival(.init(
                        festival: festival, isFavorite: isFavorite
                    )))
                    return .none
                default: return .none
                }
            case .home: return .none
            case .binding: return .none
            case .path: return .none
            case .alert: return .none
            }
        }
        .forEach(\.path, action: \.path)
        .ifLet(\.$alert, action: \.alert) {
            CustomAlert()
        }
    }
}

private extension MainFeature {
    func checkNotification() async {
        let center =  UNUserNotificationCenter.current()
        let status = await center.notificationSettings().authorizationStatus
        guard status == .authorized else { return }
        
        await MainActor.run {
            UIApplication.shared.registerForRemoteNotifications()
        }
    }
    
    func getPathState(menu: MyPageFeature.Menu) -> MainFeature.Path.State? {
        return switch menu {
        case .termsOfService: .termsOfService(.init())
        case .privacyPolicy: .privacyPolicy(.init())
        case .inquiry: nil
        }
    }
}

extension MainFeature {
    public enum Tab: CaseIterable {
        case home
        
        var name: String {
            switch self {
            case .home: "홈"
            }
        }
    }
    
    @Reducer
    public enum Path {
        case festival(FestivalFeature)
        case artistList(ArtistListFeature)
        case myPage(MyPageFeature)
        case likedFestivals(LikedFestivalsFeature)
        case subscribedFestivals(SubscribedFestivalsFeature)
        case termsOfService(TermsOfServiceFeature)
        case privacyPolicy(PrivacyPolicyFeature)
    }
}

private extension CustomAlert.State {
    static let authorization: Self = .init(
        title: "알림 권한이 없어요!",
        message: "페스티벌 정보를 받으려면\n알림 권한을 허용해주세요",
        buttonTitle: "권한 설정하기"
    )
}

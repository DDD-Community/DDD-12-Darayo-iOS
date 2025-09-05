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
import Domain

@Reducer
public struct MainFeature {
    @Dependency(\.festivalUseCase) private var festivalUseCase
    
    @ObservableState
    public struct State {
        var currentTab: Tab = .home
        var home: HomeFeature.State = .init()
        var path: StackState<Path.State> = .init()
        var url: URL?
        var shouldOpenURL: Bool = false
        @Presents var alert: CustomAlert<AlertCase>.State?
    }
    
    public enum Action: BindableAction {
        case onAppear
        case checkNotification
        case subscribeNotification
        case enteredForeground
        case home(HomeFeature.Action)
        case binding(BindingAction<State>)
        case path(StackActionOf<Path>)
        case navigateToFestival(Festival, Bool)
        case showError(NetworkError?)
        case showAlert(AlertCase)
        case alert(PresentationAction<CustomAlert<AlertCase>.Action>)
    }
    
    public init() {}
    public var body: some ReducerOf<Self> {
        BindingReducer()
        
        Scope(state: \.home, action: \.home) {
            HomeFeature()
        }
        
        Reduce { state, action in
            switch action {
            case .onAppear:
                return .merge([
                    .send(.checkNotification),
                    .send(.subscribeNotification)
                ])
            case .checkNotification:
                let id = UserDefaults.festivalID
                guard let id else { return .none }
                UserDefaults.festivalID = nil
                return .run { send in
                    await send(fetchFestival(id: id))
                }
            case .subscribeNotification:
                return .run { send in
                    let stream = NotificationCenter.default.publisher(for: .festivalID).values
                    for await notification in stream {
                        let id = notification.object as? Int
                        guard let id else { return }
                        await send(fetchFestival(id: id))
                    }
                }
            case .enteredForeground:
                return .run { _ in await checkNotification() }
            case let .home(.navigateToFestival(festival, isFavorite)):
                state.path.append(.festival(.init(festival: festival, isFavorite: isFavorite)))
                return .none
            case .home(.myPageButtonTapped):
                state.path.append(.myPage(.init()))
                return .none
            case .home(.showAlert(let alertCase)):
                return .send(.showAlert(.home(alertCase)))
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
            case .path(.element(_, .festival(.navigateToMyPage))):
                state.path.append(.myPage(.init()))
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
            case .showError(let networkError):
                guard let networkError else { return .none }
                return .send(.showAlert(.error(networkError)))
            case .showAlert(let alertCase):
                state.alert = .init(alertCase, alertCase.canDismiss)
                return .none
            case .alert(.presented(.buttonTapped(.home))):
                return .send(.home(.onRefresh))
            case .navigateToFestival(let festival, let isFavorite):
                UserDefaults.festivalID = nil
                state.path.append(.festival(.init(
                    festival: festival, isFavorite: isFavorite
                )))
                return .none
            case .home: return .none
            case .binding: return .none
            case .alert: return .none
            case .path: return .none
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
    
    func fetchFestival(id: Int) async -> Action {
        do {
            let ids = try Set(festivalUseCase.fetchLikedFestivals().map { $0.id })
            let isFavorite = ids.contains(id)
            let festival = try await festivalUseCase.fetchFestival(id: id)
            return .navigateToFestival(festival, isFavorite)
        } catch {
            let networkError = error as? NetworkError
            return .showError(networkError)
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
    
    public enum AlertCase: Equatable {
        case error(NetworkError)
        case home(HomeFeature.AlertCase)
        
        var canDismiss: Bool {
            switch self {
            case .error: return true
            case .home: return false
            }
        }
    }
}

//
//  FestivalFeature.swift
//  Home
//
//  Created by 이정원 on 6/29/25.
//  Copyright © 2025 Darayo. All rights reserved.
//

import ComposableArchitecture
import Domain
import Util
import UserNotifications
import Base

@Reducer
public struct FestivalFeature {
    public enum AlertCase {
        case authorization
    }
    
    @Dependency(\.dismiss) private var dismiss
    @Dependency(\.festivalUseCase) private var festivalUseCase
    @Dependency(\.notificationUseCase) private var notificationUseCase
    
    @ObservableState
    public struct State {
        let festival: Festival
        var isNotificationOn: Bool = false
        var isFavorite: Bool = false
        var isExpanded: Bool = true
        
        @Presents var alert: CustomAlert.State?
        var shouldOpenURL: Bool = false
        
        public init(festival: Festival, isFavorite: Bool) {
            self.festival = festival
            self.isFavorite = isFavorite
        }
        
        var dateString: String {
            let dateFormat = DateFormat.festivalWithWeekday
            let startDate = festival.startDate?.toString(dateFormat: dateFormat) ?? ""
            let endDate = festival.endDate?.toString(dateFormat: dateFormat) ?? ""
            return "\(startDate) - \(endDate)"
        }
        
        var purchaseDates: [String] {
            festival.purchaseDates.map { dates in
                let dateFormat = DateFormat.reservationWithWeekday
                let open = dates[0].toString(dateFormat: dateFormat)
                let close = dates[1].toString(dateFormat: dateFormat)
                if open == close { return "\(open)" }
                else if dates[1] == .distantFuture.startOfDay { return "\(open) - " }
                else { return "\(open) - \(close)" }
            }
        }
    }
    
    public enum Action: BindableAction {
        case onAppear
        case notificationStateFetched(Bool)
        case backButtonTapped
        case notificationButtonTapped
        case heartButtonTapped
        case updateNotification(Bool)
        case seeAllButtonTapped
        case showAlert(AlertCase?)
        case notificationUpdated(Bool)
        case navigateToArtistList([Artist])
        case binding(BindingAction<State>)
        case alert(PresentationAction<CustomAlert.Action>)
    }
    
    public init() {}
    public var body: some ReducerOf<Self> {
        BindingReducer()
        
        Reduce { state, action in
            switch action {
            case .onAppear:
                let id = state.festival.id
                return .run { send in
                    await send(fetchNotificationState(id: id))
                }
            case .notificationStateFetched(let isOn):
                state.isNotificationOn = isOn
                return .none
            case .backButtonTapped:
                return .run { _ in await dismiss() }
            case .notificationButtonTapped:
                return .send(.updateNotification(!state.isNotificationOn))
            case .heartButtonTapped:
                updateLikedFestivals(state)
                state.isFavorite = checkIsFavorite(state)
                if state.isFavorite == state.isNotificationOn { return .none }
                return .send(.updateNotification(state.isFavorite))
            case .updateNotification(let isEnabled):
                return .run { [state] send in
                    let isAuthorized = await isAuthorized
                    let shouldShowAlert = !isAuthorized && isEnabled
                    switch shouldShowAlert {
                    case true: await send(.showAlert(.authorization))
                    case false: await send(updateNotificaion(state, isEnabled: isEnabled))
                    }
                }
            case .seeAllButtonTapped:
                let artists = state.festival.artists
                return .send(.navigateToArtistList(artists))
            case .notificationUpdated(let isEnabled):
                state.isNotificationOn = isEnabled
                return .none
            case .showAlert(let alertCase):
                guard let alertCase else { return .none }
                state.alert = .init(alertCase: alertCase)
                return .none
            case .alert(.presented(.buttonTapped)):
                state.shouldOpenURL = true
                return .none
            case .navigateToArtistList: return .none
            case .binding: return .none
            case .alert: return .none
            }
        }
        .ifLet(\.$alert, action: \.alert) {
            CustomAlert()
        }
    }
}

private extension FestivalFeature {
    var isAuthorized: Bool {
        get async {
            let center =  UNUserNotificationCenter.current()
            let status = await center.notificationSettings().authorizationStatus
            return status == .authorized
        }
    }
    
    func checkIsFavorite(_ state: State) -> Bool {
        let likedFestivals = (try? festivalUseCase.fetchLikedFestivals()) ?? []
        return likedFestivals.contains { $0.id == state.festival.id }
    }
    
    func updateLikedFestivals(_ state: State) {
        let id = state.festival.id
        let isFavorite = state.isFavorite
        switch isFavorite {
        case true: try? festivalUseCase.deleteLikedFestival(id: id)
        case false: try? festivalUseCase.addLikedFestival(id: id)
        }
    }
    
    func fetchNotificationState(id: Int) async -> Action {
        let festivalID = String(id)
        do {
            let isOn = try await notificationUseCase.fetchNotificationState(id: festivalID)
            return .notificationStateFetched(isOn)
        } catch {
            return .showAlert(nil)
        }
    }
    
    func updateNotificaion(_ state: State, isEnabled: Bool) async -> Action {
        do {
            let id = state.festival.id
            try await notificationUseCase.updateNotification(id: id, isEnabled: isEnabled)
            return .notificationUpdated(isEnabled)
        } catch {
            return .showAlert(nil)
        }
    }
}

private extension CustomAlert.State {
    init(alertCase: FestivalFeature.AlertCase) {
        switch alertCase {
        case .authorization:
            self = .init(
                title: "알림 권한이 없어요!",
                message: "페스티벌 정보를 받으려면\n알림 권한을 허용해주세요",
                buttonTitle: "권한 설정하기"
            )
        }
    }
}

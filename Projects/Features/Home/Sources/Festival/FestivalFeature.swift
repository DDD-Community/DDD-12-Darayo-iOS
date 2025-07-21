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

@Reducer
public struct FestivalFeature {
    @Dependency(\.dismiss) private var dismiss
    @Dependency(\.festivalUseCase) private var festivalUseCase
    
    @ObservableState
    public struct State {
        let festival: Festival
        var isNotificationOn: Bool = false
        var isFavorite: Bool = false
        var isExpanded: Bool = true
        
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
        case backButtonTapped
        case notificationButtonTapped
        case heartButtonTapped
        case seeAllButtonTapped
        case likedFestivalsUpdated(Bool)
        case showAlert
        case navigateToArtistList([Artist])
        case binding(BindingAction<State>)
    }
    
    public init() {}
    public var body: some ReducerOf<Self> {
        BindingReducer()
        
        Reduce { state, action in
            switch action {
            case .backButtonTapped:
                return .run { _ in await dismiss() }
            case .notificationButtonTapped:
                state.isNotificationOn.toggle()
                return .none
            case .heartButtonTapped:
                let id = state.festival.id
                let isLiked = !state.isFavorite
                return .run { send in
                    await send(updateLikedFestivals(id: id, isLiked: isLiked))
                }
            case .seeAllButtonTapped:
                let artists = state.festival.artists
                return .send(.navigateToArtistList(artists))
            case .likedFestivalsUpdated(let isFavorite):
                state.isFavorite = isFavorite
                return .none
            case .showAlert: return .none
            case .navigateToArtistList: return .none
            case .binding: return .none
            }
        }
    }
}

private extension FestivalFeature {
    func updateLikedFestivals(id: Int, isLiked: Bool) async -> Action {
        do {
            switch isLiked {
            case true: try await festivalUseCase.addLikedFestival(id: id)
            case false: try await festivalUseCase.deleteLikedFestival(id: id)
            }
            let likedFestivals = try await festivalUseCase.fetchLikedFestivals()
            let isFavorite = likedFestivals.contains { $0.id == id }
            return .likedFestivalsUpdated(isFavorite)
        } catch {
            return .showAlert
        }
    }
}

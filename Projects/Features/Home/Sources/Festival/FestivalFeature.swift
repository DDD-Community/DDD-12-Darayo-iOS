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
                updateLikedFestivals(id: id, isLiked: isLiked)
                let likedFestivals = fetchLikedFestivals()
                state.isFavorite = likedFestivals.contains(id)
                return .none
            case .seeAllButtonTapped:
                let artists = state.festival.artists
                return .send(.navigateToArtistList(artists))
            case .navigateToArtistList: return .none
            case .binding: return .none
            }
        }
    }
}

private extension FestivalFeature {
    func fetchLikedFestivals() -> Set<Int> {
        let likedFestivals = (try? festivalUseCase.fetchLikedFestivals()) ?? []
        return Set(likedFestivals.map { $0.id })
    }
    
    func updateLikedFestivals(id: Int, isLiked: Bool) {
        switch isLiked {
        case true: try? festivalUseCase.addLikedFestival(id: id)
        case false: try? festivalUseCase.deleteLikedFestival(id: id)
        }
    }
}

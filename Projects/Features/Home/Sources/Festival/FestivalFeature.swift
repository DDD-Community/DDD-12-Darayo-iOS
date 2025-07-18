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
    
    @ObservableState
    public struct State {
        let festival: Festival
        var isNotificationOn: Bool = false
        var isFavorite: Bool = false
        var isExpanded: Bool = true
        
        public init(festival: Festival) {
            self.festival = festival
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
                state.isFavorite.toggle()
                return .none
            case .seeAllButtonTapped: return .none
            case .binding: return .none
            }
        }
    }
}

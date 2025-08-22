//
//  CalendarFeature.swift
//  Calendar
//
//  Created by 이다영 on 8/16/25.
//  Copyright © 2025 Darayo. All rights reserved.
//

import Foundation
import ComposableArchitecture
import Domain

@Reducer
public struct CalendarFeature {
    @ObservableState
    public struct State: Equatable {
        // 부모(Home)에서 내려주는 데이터
        public var festivals: [Festival] = []
        public var likedFestivalIDs: Set<Int> = []

        // 화면 고유 상태
        public var selectedDate: Date?
        public var isFiltered: Bool = false

        public init() {}
    }

    public enum Action: BindableAction, Equatable {
        case binding(BindingAction<State>)

        // 부모에서 최신 데이터 하달
        case setData(festivals: [Festival], likedIDs: Set<Int>)

        // 사용자 액션
        case dateSelected(Date)
        case toggleFilter
        case eventTapped(festivalId: Int)

        // 부모로 올리는 델리게이트
        case delegate(Delegate)
        public enum Delegate: Equatable {
            case openFestival(Festival, isFavorite: Bool)
            case openMyPage
        }
    }

    public init() {}

    public var body: some ReducerOf<Self> {
        BindingReducer()
        Reduce { state, action in
            switch action {
            case let .setData(fests, liked):
                state.festivals = fests
                state.likedFestivalIDs = liked
                return .none

            case let .dateSelected(date):
                state.selectedDate = date
                return .none

            case .toggleFilter:
                state.isFiltered.toggle()
                return .none

            case let .eventTapped(festivalId):
                // Domain.CalendarEvent는 festivalId를 가짐
                if let original = state.festivals.first(where: { $0.id == festivalId }) {
                    let isFav = state.likedFestivalIDs.contains(original.id)
                    return .send(.delegate(.openFestival(original, isFavorite: isFav)))
                }
                return .none

            case .binding:
                return .none
            case .delegate(_):
                return .none
            }
        }
    }
}

// MARK: - Selectors (도메인 헬퍼 그대로 활용)
public extension CalendarFeature.State {
    /// 모든 캘린더 이벤트 (행사일/예매일 모두 포함)
    var allCalendarEvents: [CalendarEvent] {
        makeCalendarEvents(from: festivals)
    }

    /// 전체 기간 기준 좋아요한 페스티벌의 모든 이벤트
    var totalLikedEvents: [CalendarEvent] {
        makeCalendarEvents(from: festivals.filter { likedFestivalIDs.contains($0.id) })
    }

    /// 선택일의 전체 이벤트
    var eventsForSelectedDate: [CalendarEvent] {
        guard let d = selectedDate else { return [] }
        return allCalendarEvents.filter { Calendar.current.isDate($0.date, inSameDayAs: d) }
    }

    /// 선택일의 좋아요 이벤트
    var likedEventsForSelectedDate: [CalendarEvent] {
        guard let d = selectedDate else { return [] }
        return totalLikedEvents.filter { Calendar.current.isDate($0.date, inSameDayAs: d) }
    }
}

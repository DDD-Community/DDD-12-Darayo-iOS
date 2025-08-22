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
  @Dependency(\.festivalUseCase) private var festivalUseCase

  @ObservableState
  public struct State: Equatable {
    public var festivals: [Festival] = []
    public var selectedDate: Date?
    public var isLoading = false
    public init() {}
  }

  public enum Action: BindableAction, Equatable {
    case binding(BindingAction<State>)
    case onAppear
    case festivalsLoaded([Festival])
    case fetchFailed
    case dateSelected(Date)
    case eventTapped(festivalId: Int)

    case delegate(Delegate)
    public enum Delegate: Equatable {
      case openFestival(Festival)
      case openMyPage
    }
  }

  public init() {}

  public var body: some ReducerOf<Self> {
    BindingReducer()

    Reduce { state, action in
      switch action {
      case .onAppear:
        guard state.festivals.isEmpty else { return .none }
        state.isLoading = true
        return .run { send in
          do {
            let festivals = try await festivalUseCase.fetchFestivals()
            await send(.festivalsLoaded(festivals))
          } catch {
            await send(.fetchFailed)
          }
        }

      case let .festivalsLoaded(fests):
        state.isLoading = false
        state.festivals = fests
        // 선택된 날짜 없으면 오늘 또는 가장 가까운 이벤트 날짜로 설정
        if state.selectedDate == nil {
          state.selectedDate = nearestEventDate(from: fests) ?? Date()
        }
        return .none

      case .fetchFailed:
        state.isLoading = false
        return .none

      case let .dateSelected(d):
        state.selectedDate = d
        return .none

      case let .eventTapped(id):
        if let festival = state.festivals.first(where: { $0.id == id }) {
          return .send(.delegate(.openFestival(festival)))
        }
        return .none

      case .binding, .delegate:
        return .none
      }
    }
  }
}

// MARK: - Selectors
public extension CalendarFeature.State {
  var allCalendarEvents: [CalendarEvent] {
    makeCalendarEvents(from: festivals)
  }
  var eventsForSelectedDate: [CalendarEvent] {
    guard let d = selectedDate else { return [] }
    return allCalendarEvents.filter { Calendar.current.isDate($0.date, inSameDayAs: d) }
  }
}

// MARK: - Helpers
private func nearestEventDate(from festivals: [Festival]) -> Date? {
  let events = makeCalendarEvents(from: festivals)
  return events.min(by: { abs($0.date.timeIntervalSinceNow) < abs($1.date.timeIntervalSinceNow) })?.date
}

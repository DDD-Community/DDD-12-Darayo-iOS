//
//  HomeCalendarView.swift
//  Home
//
//  Created by 이정원 on 6/29/25.
//  Copyright © 2025 Darayo. All rights reserved.
//

import SwiftUI
import ComposableArchitecture
import DesignSystem
import Domain

public struct CalendarScreen: View {
    @Bindable private var store: StoreOf<CalendarFeature>

    public init(store: StoreOf<CalendarFeature>) {
        self.store = store
    }

    public var body: some View {
        ZStack {
            Color.background1.ignoresSafeArea()
            ScrollView {
                VStack(spacing: 0) {
                    calendarSection
                        .padding(.top, 16)

                    eventListSection
                        .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .top)
                        .padding(.top, 20)
                }
            }
        }
    }
}

private extension CalendarScreen {
    var calendarSection: some View {
        CalendarView(
            calendarEvents: store.allCalendarEvents,
            selectedDate: store.selectedDate,
            onDateSelected: { date in
                store.send(.dateSelected(date))
            },
            onMonthChanged: { _ in }
        )
    }

    var eventListSection: some View {
        EventListView(
            events: store.eventsForSelectedDate,             // 선택일 전체
            allEvents: store.likedEventsForSelectedDate,     // 선택일 좋아요
            totalLikedEvents: store.totalLikedEvents,        // 전체 기간 좋아요
            title: "좋아요한 페스티벌",
            isFiltered: store.isFiltered,
            onTap: { event in
                store.send(.eventTapped(festivalId: event.festivalId))
            },
            onToggleFilter: {
                store.send(.toggleFilter)
            }
        )
    }
}

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

struct HomeCalendarView: View {
    private let store: StoreOf<HomeFeature>
    
    init(store: StoreOf<HomeFeature>) {
        self.store = store
    }
    
    var body: some View {
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

private extension HomeCalendarView {
    private var calendarSection: some View {
        CalendarView(
            calendar: calendar,
            onDateSelected: { date in
                store.send(.dateSelected(date))
            },
            onMonthChanged: { _ in
                
            }
        )
    }
    
    private var eventListSection: some View {
            EventListView(
                events: eventsForSelectedDate, allEvents: calendar.events,
                title: "좋아요한 페스티벌"
            )
    }
}

private extension HomeCalendarView {
    var calendar: CalendarModel {
        CalendarModel(events: events)
    }
    
    var events: [CalendarModel.Event] {
        DummyEventData.events
    }
    
    var eventsForSelectedDate: [CalendarModel.Event] {
        guard let selectedDate = store.selectedDate else { return [] }
        return calendar.events.filter { event in
            Calendar.current.isDate(event.date, inSameDayAs: selectedDate)
        }
    }
}

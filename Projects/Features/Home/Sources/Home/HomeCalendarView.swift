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

struct HomeCalendarView: View {
    private let store: StoreOf<HomeFeature>
    
    init(store: StoreOf<HomeFeature>) {
        self.store = store
    }
    
    var body: some View {
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

private extension HomeCalendarView {
    private var calendarSection: some View {
        CalendarView(
            calendarEvents: calendarEvents,
            selectedDate: store.selectedDate,
            onDateSelected: { date in
                store.send(.dateSelected(date))
            },
            onMonthChanged: { _ in }
        )
    }
    
    private var eventListSection: some View {
        EventListView(
            events: eventsForSelectedDate,
            allEvents: filteredLikedEventsForSelectedDate,
            totalLikedEvents: makeCalendarEvents(from: store.favoriteFestivals),
            title: "좋아요한 페스티벌",
            isFiltered: store.isFiltered,
            onTap: { event in
                if let festival = store.allFestivals.first(where: { $0.id == event.festivalId }) {
                    store.send(.festivalTapped(festival))
                }
            },
            onToggleFilter: {
                        store.send(.set(\.isFiltered, !store.isFiltered))
            }
        )
    }
    
    private var filteredLikedEventsForSelectedDate: [CalendarEvent] {
        guard let selectedDate = store.selectedDate else { return [] }

        let likedFestivals = store.favoriteFestivals
        let likedEvents = makeCalendarEvents(from: likedFestivals)

        return likedEvents.filter { event in
            Calendar.current.isDate(event.date, inSameDayAs: selectedDate)
        }
    }

}

private extension HomeCalendarView {
    var calendarEvents: [CalendarEvent] {
        makeCalendarEvents(from: store.festivals)
    }
    
    var eventsForSelectedDate: [CalendarEvent] {
        guard let selectedDate = store.selectedDate else {
            return []
        }
        
        let currentEvents = makeCalendarEvents(from: store.festivals)
        return currentEvents.filter { event in
            Calendar.current.isDate(event.date, inSameDayAs: selectedDate)
        }
    }
}

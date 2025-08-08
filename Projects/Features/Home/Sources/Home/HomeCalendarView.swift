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

public struct HomeCalendarView: View {
    @Bindable private var store: StoreOf<HomeFeature>
    
    public init(store: StoreOf<HomeFeature>) {
        self.store = store
    }
    
    public var body: some View {
        ZStack {
            Color.background1.ignoresSafeArea()
            VStack(spacing: 0) {
                navigationBar
                
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
}

private extension HomeCalendarView {
    var navigationBar: some View {
        HStack {
            Image.logo
            Spacer()
            Button {
                store.send(.myPageButtonTapped)
            } label: {
                Image.iconMyPage
                    .renderingMode(.template)
                    .resizable()
                    .frame(width: 24, height: 24)
                    .foregroundStyle(Color.grey4)
            }
        }
        .padding(.vertical, 10)
        .padding(.horizontal, 16)
    }
    
    var calendarSection: some View {
        CalendarView(
            calendarEvents: calendarEvents,
            selectedDate: store.selectedDate,
            onDateSelected: { date in
                store.send(.dateSelected(date))
            },
            onMonthChanged: { _ in }
        )
    }
    
    var eventListSection: some View {
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
    
    var filteredLikedEventsForSelectedDate: [CalendarEvent] {
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

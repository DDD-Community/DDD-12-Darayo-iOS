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
            calendar: calendar,
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
            totalLikedEvents: makeEvents(from: store.favoriteFestivals),
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
    
    private var filteredLikedEventsForSelectedDate: [CalendarModel.Event] {
        guard let selectedDate = store.selectedDate else { return [] }

        let likedFestivals = store.favoriteFestivals
        let likedEvents = makeEvents(from: likedFestivals)

        return likedEvents.filter { event in
            Calendar.current.isDate(event.date, inSameDayAs: selectedDate)
        }
    }

}

private extension HomeCalendarView {
    var calendar: CalendarModel {
        CalendarModel(events: events)
    }
    
    var events: [CalendarModel.Event] {
        makeEvents(from: store.festivals)
    }
    
    var eventsForSelectedDate: [CalendarModel.Event] {
        guard let selectedDate = store.selectedDate else {
            return []
        }
        
        let currentEvents = makeEvents(from: store.festivals)
        return currentEvents.filter { event in
            Calendar.current.isDate(event.date, inSameDayAs: selectedDate)
        }
    }
}

private func makeEvents(from festivals: [Festival]) -> [CalendarModel.Event] {
    festivals.flatMap { festival in
        var events: [CalendarModel.Event] = []
        
        // category: 예매일
        if let openDate = festival.reservations.first?.openDateTime {
            let vendorNames = festival.reservations
                .compactMap { $0.vendor.name }
                .joined(separator: " · ")
            
            events.append(CalendarModel.Event(
                id: UUID().uuidString,
                festivalId: festival.id,
                title: festival.name,
                location: vendorNames,
                date: openDate,
                time: openDate.toString(dateFormat: .reservateionDateTime),
                category: .reservationDay,
                posterURL: URL(string: festival.posterURLString)
            ))
        }
        
        // category: 행사일
        if let startDate = festival.startDate, let endDate = festival.endDate {
            var currentDate = startDate
            let calendar = Calendar.current
            
            while currentDate <= endDate {
                events.append(CalendarModel.Event(
                    id: UUID().uuidString,
                    festivalId: festival.id,
                    title: festival.name,
                    location: festival.placeName,
                    date: currentDate,
                    endDate: endDate,
                    time: "\(startDate.toString(dateFormat: .eventDate)) - \(endDate.toString(dateFormat: .eventDate))",
                    category: .festivalDay,
                    posterURL: URL(string: festival.posterURLString)
                ))
                guard let nextDay = calendar.date(byAdding: .day, value: 1, to: currentDate) else { break }
                currentDate = nextDay
            }
        }
        
        return events
    }
}

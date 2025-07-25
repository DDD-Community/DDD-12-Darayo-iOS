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
            onDateSelected: { date in
                store.send(.dateSelected(date))
            },
            onMonthChanged: { _ in
                
            }
        )
    }
    
    private var eventListSection: some View {
            EventListView(
                events: eventsForSelectedDate,
                allEvents: calendar.events,
                title: "좋아요한 페스티벌",
                onTap: { event in
                    if let festival = store.allFestivals.first(where: { $0.id == event.festivalId }) {
                        store.send(.festivalTapped(festival))
                    }
                }
            )
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
        guard let selectedDate = store.selectedDate else { return [] }
        return calendar.events.filter { event in
            Calendar.current.isDate(event.date, inSameDayAs: selectedDate)
        }
    }
}

private func makeEvents(from festivals: [Festival]) -> [CalendarModel.Event] {
    festivals.flatMap { festival in
        var events: [CalendarModel.Event] = []
        
        // catrgory: 예매일
        if let openDate = festival.reservations.first?.openDateTime {
            let vendorNames = festival.reservations
                .compactMap { $0.vendor.name }
                .joined(separator: " · ")
            
            events.append(CalendarModel.Event(
                id: UUID().uuidString,
                festivalId: festival.id,
                title: festival.name,
                location: vendorNames, // 예매처
                date: openDate,
                time: openDate.toString(dateFormat: .reservateionDateTime), // 예매일
                category: .reservationDay,
                posterURL: URL(string: festival.posterURLString)
            ))
        }
        
        // catrgory: 행사일
        if let startDate = festival.startDate, let endDate = festival.endDate {
            let calendar = Calendar.current
            var currentDate = startDate

            while currentDate <= endDate {
                events.append(CalendarModel.Event(
                    id: UUID().uuidString,
                    festivalId: festival.id,
                    title: festival.name,
                    location: festival.placeName, // 행사 장소
                    date: currentDate,
                    endDate: endDate,
                    time: "\(startDate.toString(dateFormat: .eventDate)) - \(endDate.toString(dateFormat: .eventDate))", // 행사일
                    category: .festivalDay,
                    posterURL: URL(string: festival.posterURLString)
                ))
                // 다음 날로 이동
                guard let nextDay = calendar.date(byAdding: .day, value: 1, to: currentDate) else { break }
                currentDate = nextDay
            }
        }
        
        return events
    }
}

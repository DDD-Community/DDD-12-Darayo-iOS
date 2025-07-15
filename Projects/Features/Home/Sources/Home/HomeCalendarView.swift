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
        
        VStack(spacing: 20) {
            calendarSection
            eventListSection
        }
        .padding(.top, 16)
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
        VStack(spacing: 0) {
            EventListView(
                events: eventsForSelectedDate,
                title: "좋아요한 페스티벌"
            )
        }
    }
}

private extension HomeCalendarView {
    var calendar: CalendarModel {
        CalendarModel(events: events)
    }
    
    var events: [CalendarModel.Event] {
        [
            CalendarModel.Event(
                title: "페스티벌명 최대 1줄",
                location: "예매처 인터파크",
                date: Foundation.Calendar.current.date(from: DateComponents(year: 2025, month: 6, day: 26))!,
                time: "25.06.12 18:00",
                category: .reservationDay
            ),
            CalendarModel.Event(
                title: "페스티벌명 최대 1줄",
                location: "장소 인천 송도 달빛광장",
                date: Foundation.Calendar.current.date(from: DateComponents(year: 2025, month: 6, day: 26))!,
                time: "25.08.01 - 25.08.03",
                category: .festivalDay
            ),
            CalendarModel.Event(
                title: "여름 음악 페스티벌",
                location: "장소 서울 올림픽공원",
                date: Foundation.Calendar.current.date(from: DateComponents(year: 2025, month: 6, day: 28))!,
                time: "25.07.15 19:00",
                category: .reservationDay
            ),
            CalendarModel.Event(
                title: "록 페스티벌 2025",
                location: "장소 부산 해운대",
                date: Foundation.Calendar.current.date(from: DateComponents(year: 2025, month: 6, day: 30))!,
                time: "25.09.10 - 25.09.12",
                category: .festivalDay
            )
        ]
    }
    
    var eventsForSelectedDate: [CalendarModel.Event] {
        guard let selectedDate = store.selectedDate else { return [] }
        return calendar.events.filter { event in
            Calendar.current.isDate(event.date, inSameDayAs: selectedDate)
        }
    }
}

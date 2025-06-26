//
//  CalendarDemoView.swift
//  DesignSystemDemo
//
//  Created by 이다영 on 6/26/25.
//  Copyright © 2025 Darayo. All rights reserved.
//

import SwiftUI
import DesignSystem

struct CalendarDemoView: View {
    @State private var selectedDate: Date? = Date()
    @State private var calendar: CalendarModel = CalendarModel(events: DummyEventData.events)
    @State private var showCalendarView = false

    var body: some View {
        NavigationView {
            VStack(spacing: 0) {
                calendarSection
                
                if !eventsForSelectedDate.isEmpty {
                    EventListView(events: eventsForSelectedDate)
                } else {
                    Spacer()
                }
            }
            .background(Color.black)
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    HStack(spacing: 16) {
                        Button(action: {
                            // 왼쪽 버튼 액션 (빈 상태)
                        }) {
                            Image(systemName: "square.grid.2x2.fill")
                                .foregroundColor(.white)
                                .font(.title3)
                        }
                        
                        Button(action: {
                            showCalendarView.toggle()
                        }) {
                            Image(systemName: "list.bullet")
                                .foregroundColor(.white)
                                .font(.title3)
                        }
                    }
                }
            }
        }
    }
    
    private var calendarSection: some View {
        CalendarView(
            calendar: calendar,
            onDateSelected: { date in
                selectedDate = date
            },
            onMonthChanged: { month in
                // 월이 변경될 때 필요한 로직
            }
        )
    }
    
    private var eventsForSelectedDate: [CalendarModel.Event] {
        guard let selectedDate = selectedDate else { return [] }
        return calendar.events.filter { event in
            Foundation.Calendar.current.isDate(event.date, inSameDayAs: selectedDate)
        }
    }
}

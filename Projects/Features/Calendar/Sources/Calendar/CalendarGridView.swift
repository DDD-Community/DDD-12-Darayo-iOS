//
//  CalendarGridView.swift
//  DesignSystem
//
//  Created by 이다영 on 6/28/25.
//  Copyright © 2025 Darayo. All rights reserved.
//

import SwiftUI
import Domain

struct CalendarGridView: View {
    let currentMonth: Date
    let selectedDate: Date?
    let calendarEvents: [CalendarEvent]
    let dates: [Date]
    let onDateSelected: (Date) -> Void
    
    var body: some View {
        LazyVGrid(columns: CalendarLayout.columns, spacing: 4) {
            ForEach(dates, id: \.self) { date in
                CalendarDayCell(
                    date: date,
                    currentMonth: currentMonth,
                    selectedDate: selectedDate,
                    events: eventsForDate(date),
                    onDateSelected: onDateSelected
                )
            }
        }
    }
    
    private func eventsForDate(_ date: Date) -> [CalendarEvent] {
        return calendarEvents.filter { event in
            Foundation.Calendar.current.isDate(event.date, inSameDayAs: date)
        }
    }
}

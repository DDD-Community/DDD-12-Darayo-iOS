//
//  CalendarView.swift
//  DesignSystem
//
//  Created by 이다영 on 6/26/25.
//  Copyright © 2025 Darayo. All rights reserved.
//

import SwiftUI
import Domain

public struct CalendarView: View {
    let calendarEvents: [CalendarEvent]
    let selectedDate: Date?
    let onDateSelected: (Date) -> Void
    let onMonthChanged: (Date) -> Void
    let onLikedFestivalsRequested: () -> Void
    
    @State private var currentMonth: Date = Date()
    
    public init(
        calendarEvents: [CalendarEvent],
        selectedDate: Date?,
        onDateSelected: @escaping (Date) -> Void,
        onMonthChanged: @escaping (Date) -> Void,
        onLikedFestivalsRequested: @escaping () -> Void = {}
    ) {
        self.calendarEvents = calendarEvents
        self.selectedDate = selectedDate
        self.onDateSelected = onDateSelected
        self.onMonthChanged = onMonthChanged
        self.onLikedFestivalsRequested = onLikedFestivalsRequested
    }
    
    public var body: some View {
        VStack(spacing: 10) {
            // 월 네비게이션
            MonthNavigationView(
                currentMonth: currentMonth,
                onPreviousMonth: previousMonth,
                onNextMonth: nextMonth
            )
            
            // 요일 헤더
            WeekdayHeaderView()
            
            // 캘린더 그리드
            CalendarGridView(
                currentMonth: currentMonth,
                selectedDate: selectedDate,
                calendarEvents: calendarEvents,
                dates: calendarDates,
                onDateSelected: { date in
                    onDateSelected(date)
                }
            )
        }
        .frame(maxWidth: .infinity, alignment: .topLeading)
    }
    
    private var calendarDates: [Date] {
        CalendarGridDataProvider.makeCalendarDates(for: currentMonth)
    }
    
    private func previousMonth() {
        currentMonth = Foundation.Calendar.current.date(byAdding: .month, value: -1, to: currentMonth) ?? currentMonth
        onMonthChanged(currentMonth)
    }
    
    private func nextMonth() {
        currentMonth = Foundation.Calendar.current.date(byAdding: .month, value: 1, to: currentMonth) ?? currentMonth
        onMonthChanged(currentMonth)
    }
}

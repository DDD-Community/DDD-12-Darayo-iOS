//
//  CalendarView.swift
//  DesignSystem
//
//  Created by 이다영 on 6/26/25.
//  Copyright © 2025 Darayo. All rights reserved.
//

import SwiftUI

public struct CalendarView: View {
    let calendar: CalendarModel
    let selectedDate: Date?
    let onDateSelected: (Date) -> Void
    let onMonthChanged: (Date) -> Void
    
    @State private var currentMonth: Date = Date()
    
    public init(
        calendar: CalendarModel,
        selectedDate: Date?,
        onDateSelected: @escaping (Date) -> Void,
        onMonthChanged: @escaping (Date) -> Void
    ) {
        self.calendar = calendar
        self.selectedDate = selectedDate
        self.onDateSelected = onDateSelected
        self.onMonthChanged = onMonthChanged
    }
    
    public var body: some View {
        VStack(spacing: 20) {
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
                calendar: calendar,
                dates: calendarDates,
                onDateSelected: { date in
                    onDateSelected(date)
                }
            )
        }
        .padding(.horizontal, 16)
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

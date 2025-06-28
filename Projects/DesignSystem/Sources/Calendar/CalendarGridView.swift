//
//  CalendarGridView.swift
//  DesignSystem
//
//  Created by 이다영 on 6/28/25.
//  Copyright © 2025 Darayo. All rights reserved.
//

import SwiftUI

struct CalendarGridView: View {
    let currentMonth: Date
    let selectedDate: Date?
    let calendar: CalendarModel
    let onDateSelected: (Date) -> Void
    
    var body: some View {
        LazyVGrid(columns: Array(repeating: GridItem(.flexible(), spacing: 0), count: 7), spacing: 12) {
            ForEach(calendarDays, id: \.self) { date in
                CalendarDayCell(
                    date: date,
                    currentMonth: currentMonth,
                    selectedDate: selectedDate,
                    hasEvent: hasEvent(for: date),
                    onDateSelected: onDateSelected
                )
            }
        }
    }
    
    private var calendarDays: [Date] {
        let calendar = Foundation.Calendar.current
        let startOfMonth = calendar.dateInterval(of: .month, for: currentMonth)!.start
        
        // 월요일을 첫 번째 요일로 설정
        var startOfCalendar = startOfMonth
        let weekday = calendar.component(.weekday, from: startOfMonth)
        let daysFromMonday = (weekday + 5) % 7 // 월요일을 0으로 만들기
        startOfCalendar = calendar.date(byAdding: .day, value: -daysFromMonday, to: startOfMonth)!
        
        var days: [Date] = []
        var currentDate = startOfCalendar
        
        // 6주간의 날짜 생성 (42일)
        for _ in 0..<42 {
            days.append(currentDate)
            currentDate = calendar.date(byAdding: .day, value: 1, to: currentDate)!
        }
        
        return days
    }
    
    private func hasEvent(for date: Date) -> Bool {
        return calendar.events.contains { event in
            Foundation.Calendar.current.isDate(event.date, inSameDayAs: date)
        }
    }
}

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
    let onDateSelected: (Date) -> Void
    let onMonthChanged: (Date) -> Void
    
    @State private var currentMonth: Date = Date()
    @State private var selectedDate: Date? = Date()
    
    public init(
        calendar: CalendarModel,
        onDateSelected: @escaping (Date) -> Void,
        onMonthChanged: @escaping (Date) -> Void
    ) {
        self.calendar = calendar
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
                    selectedDate = date
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

#Preview {
    CalendarViewPreviewWrapper()
        .background(Color.black)
}

private struct CalendarViewPreviewWrapper: View {
    var body: some View {
        CalendarView(
            calendar: CalendarModel(events: dummyEvents),
            onDateSelected: { date in
//                print("Selected date:", date)
            },
            onMonthChanged: { newMonth in
//                print("Changed month:", newMonth)
            }
        )
    }

    private var dummyEvents: [CalendarModel.Event] {
        return [
            CalendarModel.Event(
                id: UUID().uuidString,
                title: "테스트 페스티벌",
                location: "예스24",
                date: Date(),
                time: "25.06.28 18:00",
                category: .reservationDay
            ),
            CalendarModel.Event(
                id: UUID().uuidString,
                title: "다음 달 행사",
                location: "인터파크",
                date: Calendar.current.date(byAdding: .month, value: 1, to: Date())!,
                time: "25.07.10 19:00",
                category: .festivalDay
            )
        ]
    }
}

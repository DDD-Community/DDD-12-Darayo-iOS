//
//  CalendarView.swift
//  DesignSystem
//
//  Created by 이다영 on 6/26/25.
//  Copyright © 2025 Darayo. All rights reserved.
//

import SwiftUI

public struct CalendarView: View {
    @State private var currentMonth: Date = Date()
    @State private var selectedDate: Date? = Date()
    
    private let calendar: CalendarModel
    private let onDateSelected: (Date) -> Void
    private let onMonthChanged: (Date) -> Void
    
    public init(
        calendar: CalendarModel,
        onDateSelected: @escaping (Date) -> Void = { _ in },
        onMonthChanged: @escaping (Date) -> Void = { _ in }
    ) {
        self.calendar = calendar
        self.onDateSelected = onDateSelected
        self.onMonthChanged = onMonthChanged
    }
    
    public var body: some View {
        VStack(spacing: 0) {
            header
            calendarContent
        }
    }
    
    private var eventsForSelectedDate: [CalendarModel.Event] {
        guard let selectedDate = selectedDate else { return [] }
        return calendar.events.filter { event in
            Foundation.Calendar.current.isDate(event.date, inSameDayAs: selectedDate)
        }
    }
}

private extension CalendarView {
    var header: some View {
        HStack {
            Button(action: {
                currentMonth = Foundation.Calendar.current.date(byAdding: .month, value: -1, to: currentMonth) ?? currentMonth
                onMonthChanged(currentMonth)
            }) {
                Image(systemName: "chevron.left")
                    .foregroundStyle(.white)
                    .font(.title2)
            }

            Spacer()

            Text(koreanMonthYear(from: currentMonth))
                .font(.title2)
                .fontWeight(.medium)
                .foregroundStyle(.white)

            Spacer()

            Button(action: {
                currentMonth = Foundation.Calendar.current.date(byAdding: .month, value: 1, to: currentMonth) ?? currentMonth
                onMonthChanged(currentMonth)
            }) {
                Image(systemName: "chevron.right")
                    .foregroundStyle(.white)
                    .font(.title2)
            }
        }
        .padding(.horizontal, 20)
        .padding(.vertical, 16)
    }

    var calendarContent: some View {
        VStack(spacing: 16) {
            weekdayHeader
            calendarGrid
        }
        .padding(.horizontal, 20)
    }

    var weekdayHeader: some View {
        let koreanWeekdays = ["월", "화", "수", "목", "금", "토", "일"]

        return HStack(spacing: 0) {
            ForEach(koreanWeekdays.indices, id: \.self) { i in
                Text(koreanWeekdays[i])
                    .font(.system(size: 14, weight: .medium))
                    .foregroundColor(.gray)
                    .frame(maxWidth: .infinity)
            }
        }
    }

    var calendarGrid: some View {
        let daysInMonth = CalendarHelper.numberOfDays(in: currentMonth)
        let firstWeekday = CalendarHelper.firstWeekdayOfMonth(in: currentMonth)
        let adjustedFirstWeekday = firstWeekday == 1 ? 6 : firstWeekday - 2
        let numberOfRows = Int(ceil(Double(daysInMonth + adjustedFirstWeekday) / 7.0))
        let totalCells = numberOfRows * 7
        let previousMonth = Foundation.Calendar.current.date(byAdding: .month, value: -1, to: currentMonth) ?? currentMonth
        let daysInPreviousMonth = CalendarHelper.numberOfDays(in: previousMonth)
        
        return LazyVGrid(columns: Array(repeating: GridItem(.flexible(), spacing: 4), count: 7), spacing: 8) {
            ForEach(0..<totalCells, id: \.self) { index in
                CalendarCell(
                    index: index,
                    adjustedFirstWeekday: adjustedFirstWeekday,
                    daysInMonth: daysInMonth,
                    daysInPreviousMonth: daysInPreviousMonth,
                    currentMonth: currentMonth,
                    selectedDate: selectedDate,
                    events: calendar.events
                ) { date in
                    selectedDate = date
                    onDateSelected(date)
                }
            }
        }
        .padding(.top, 8)
    }
    
    func koreanMonthYear(from date: Date) -> String {
        let year = Foundation.Calendar.current.component(.year, from: date)
        let month = Foundation.Calendar.current.component(.month, from: date)
        return "\(year). \(String(format: "%02d", month))"
    }
}

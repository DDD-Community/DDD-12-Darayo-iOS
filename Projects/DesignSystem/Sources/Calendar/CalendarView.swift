//
//  CalendarView.swift
//  DesignSystem
//
//  Created by 이다영 on 6/26/25.
//  Copyright © 2025 Darayo. All rights reserved.
//

import SwiftUI
//import DesignSystem

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
            // 왼쪽 화살표
            Button(action: {
                currentMonth = Foundation.Calendar.current.date(byAdding: .month, value: -1, to: currentMonth) ?? currentMonth
                onMonthChanged(currentMonth)
            }) {
                ZStack {
                    RoundedRectangle(cornerRadius: 6)
                        .fill(Color.background2)
                        .frame(width: 24, height: 24)
                    
                    Image(systemName: "chevron.left")
                        .resizable()
                        .frame(width: 7.43, height: 13)
                        .foregroundColor(.white)
                }
            }

            Spacer()

            // 년 & 월
            Text(koreanMonthYear(from: currentMonth))
                .pretendard(style: .title4)
                .foregroundStyle(.white)

            Spacer()

            // 오른쪽 화살표
            Button(action: {
                currentMonth = Foundation.Calendar.current.date(byAdding: .month, value: 1, to: currentMonth) ?? currentMonth
                onMonthChanged(currentMonth)
            }) {
                ZStack {
                    RoundedRectangle(cornerRadius: 6)
                        .fill(Color.background2)
                        .frame(width: 24, height: 24)
                    
                    Image(systemName: "chevron.right")
                        .resizable()
                        .frame(width: 7.43, height: 13)
                        .foregroundColor(.white)
                }
            }
        }
        .padding(.horizontal, 15)
        .padding(.vertical, 16)
    }

    var calendarContent: some View {
        VStack(spacing: 0) {
            weekdayHeader
            calendarGrid
        }
        .padding(.horizontal, 10)
    }

    var weekdayHeader: some View {
        let koreanWeekdays = ["월", "화", "수", "목", "금", "토", "일"]

        return HStack(spacing: 23) {
            ForEach(koreanWeekdays.indices, id: \.self) { i in
                Text(koreanWeekdays[i])
                    .pretendard(style: .caption2)
                    .foregroundColor(.gray)
                    .frame(width: 36, height: 36)
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
        
        return LazyVGrid(columns: Array(repeating: GridItem(.flexible(), spacing: 30), count: 7), spacing: 8) {
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
    }
    
    func koreanMonthYear(from date: Date) -> String {
        let year = Foundation.Calendar.current.component(.year, from: date)
        let month = Foundation.Calendar.current.component(.month, from: date)
        return "\(year). \(String(format: "%02d", month))"
    }
}

#Preview {
    CalendarView(
        calendar: CalendarModel(
            events: [
                CalendarModel.Event(
                    id: UUID().uuidString,
                    title: "서울 재즈 페스티벌",
                    location: "예스24",
                    date: Date(),
                    time: "25.07.20 19:30",
                    category: .festivalDay
                ),
                CalendarModel.Event(
                    id: UUID().uuidString,
                    title: "인천 펜타포트 락 페스티벌",
                    location: "인터파크",
                    date: Date(),
                    time: "25.06.12 18:00",
                    category: .reservationDay
                )
            ]
        )
    )
    .background(Color.black)
}


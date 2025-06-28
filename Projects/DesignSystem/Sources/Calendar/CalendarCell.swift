////
////  CalendarCell.swift
////  DesignSystem
////
////  Created by 이다영 on 6/26/25.
////  Copyright © 2025 Darayo. All rights reserved.
////
//
//import SwiftUI
//import DesignSystem
//
//public struct CalendarCell: View {
//    let index: Int
//    let adjustedFirstWeekday: Int
//    let daysInMonth: Int
//    let daysInPreviousMonth: Int
//    let currentMonth: Date
//    let selectedDate: Date?
//    let events: [CalendarModel.Event]
//    let onDateSelected: (Date) -> Void
//    
//    public init(
//        index: Int,
//        adjustedFirstWeekday: Int,
//        daysInMonth: Int,
//        daysInPreviousMonth: Int,
//        currentMonth: Date,
//        selectedDate: Date?,
//        events: [CalendarModel.Event],
//        onDateSelected: @escaping (Date) -> Void
//    ) {
//        self.index = index
//        self.adjustedFirstWeekday = adjustedFirstWeekday
//        self.daysInMonth = daysInMonth
//        self.daysInPreviousMonth = daysInPreviousMonth
//        self.currentMonth = currentMonth
//        self.selectedDate = selectedDate
//        self.events = events
//        self.onDateSelected = onDateSelected
//    }
//    
//    public var body: some View {
//        let dayNumber: Int
//        let isCurrentMonth: Bool
//        let cellDate: Date
//        
//        if index < adjustedFirstWeekday {
//            dayNumber = daysInPreviousMonth - adjustedFirstWeekday + index + 1
//            isCurrentMonth = false
//            cellDate = Foundation.Calendar.current.date(byAdding: .day, value: index - adjustedFirstWeekday, to: CalendarHelper.firstDateOfMonth(currentMonth)) ?? Date()
//        } else if index < adjustedFirstWeekday + daysInMonth {
//            dayNumber = index - adjustedFirstWeekday + 1
//            isCurrentMonth = true
//            cellDate = CalendarHelper.date(at: index - adjustedFirstWeekday, in: currentMonth)
//        } else {
//            dayNumber = index - adjustedFirstWeekday - daysInMonth + 1
//            isCurrentMonth = false
//            cellDate = Foundation.Calendar.current.date(byAdding: .day, value: index - adjustedFirstWeekday, to: CalendarHelper.firstDateOfMonth(currentMonth)) ?? Date()
//        }
//        
//        let hasEvent = events.contains { event in
//            Foundation.Calendar.current.isDate(event.date, inSameDayAs: cellDate)
//        }
//        
//        return Button {
//            if isCurrentMonth {
//                onDateSelected(cellDate)
//            }
//        } label: {
//            VStack(spacing: 2) {
//                ZStack {
//                    if let selectedDate = selectedDate,
//                       Foundation.Calendar.current.isDate(cellDate, inSameDayAs: selectedDate) {
//                        RoundedRectangle(cornerRadius: 8)
//                            .fill(Color.yellow)
//                            .frame(width: 36, height: 36)
//                    }
//                    
//                    Text("\(dayNumber)")
//                        .pretendard(style: .body3)
//                        .foregroundStyle(
//                            selectedDate != nil && Foundation.Calendar.current.isDate(cellDate, inSameDayAs: selectedDate!)
//                            ? .black
//                            : (isCurrentMonth ? .white : .gray.opacity(0.5))
//                        )
//                        .frame(width: 36, height: 36)
//                }
//                
//                if hasEvent && isCurrentMonth {
//                    Circle()
//                        .fill(Color.yellow)
//                        .frame(width: 4, height: 4)
//                } else {
//                    Circle()
//                        .fill(Color.clear)
//                        .frame(width: 4, height: 4)
//                }
//            }
//        }
//        .disabled(!isCurrentMonth)
//    }
//}
//#Preview {
//    CalendarCellPreview()
//        .padding()
//        .background(Color.black)
//}
//
//private struct CalendarCellPreview: View {
//    @State private var selectedDate: Date? = Date()
//
//    var body: some View {
//        CalendarCell(
//            index: 10,
//            adjustedFirstWeekday: 2,
//            daysInMonth: 30,
//            daysInPreviousMonth: 31,
//            currentMonth: Date(),
//            selectedDate: selectedDate,
//            events: [
//                CalendarModel.Event(
//                    id: UUID().uuidString,
//                    title: "테스트 이벤트",
//                    location: "예스24",
//                    date: Date(),
//                    time: "25.07.20 19:30",
//                    category: .festivalDay
//                )
//            ],
//            onDateSelected: { date in
//                selectedDate = date
//            }
//        )
//    }
//}
//

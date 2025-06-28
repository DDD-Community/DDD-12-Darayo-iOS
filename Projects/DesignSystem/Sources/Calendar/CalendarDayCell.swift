//
//  CalendarDayCell.swift
//  DesignSystem
//
//  Created by 이다영 on 6/28/25.
//  Copyright © 2025 Darayo. All rights reserved.
//

import SwiftUI

struct CalendarDayCell: View {
    let date: Date
    let currentMonth: Date
    let selectedDate: Date?
    let hasEvent: Bool
    let onDateSelected: (Date) -> Void
    
    private var dayNumber: Int {
        Foundation.Calendar.current.component(.day, from: date)
    }
    
    private var isToday: Bool {
        Foundation.Calendar.current.isDateInToday(date)
    }
    
    private var isSelected: Bool {
        guard let selectedDate = selectedDate else { return false }
        return Foundation.Calendar.current.isDate(date, inSameDayAs: selectedDate)
    }
    
    private var isCurrentMonth: Bool {
        Foundation.Calendar.current.isDate(date, equalTo: currentMonth, toGranularity: .month)
    }
    
    var body: some View {
        ZStack {
            // 오늘 날짜 배경
            if isToday {
                Image.iconCalendarToday
                    .resizable()
                    .aspectRatio(contentMode: .fit)
                    .frame(width: 32, height: 32)
            }
            
            // 선택된 날짜 배경
            if isSelected && !isToday {
                Circle()
                    .fill(Color.point1)
                    .frame(width: 32, height: 32)
            }
            
            VStack(spacing: 2) {
                // 날짜 숫자
                Text("\(dayNumber)")
                    .pretendard(style: .body3)
                    .foregroundColor(textColor)
                
                // 이벤트 dot
                if hasEvent && isCurrentMonth {
                    Circle()
                        .fill(Color.point1)
                        .frame(width: 4, height: 4)
                } else {
                    // 공간 유지를 위한 투명한 dot
                    Circle()
                        .fill(Color.clear)
                        .frame(width: 4, height: 4)
                }
            }
        }
        .frame(height: 30)
        .contentShape(Rectangle())
        .onTapGesture {
            if isCurrentMonth {
                onDateSelected(date)
            }
        }
    }
    
    private var textColor: Color {
        if !isCurrentMonth {
            return .grey5
        } else if isToday {
            return .black
        } else if isSelected {
            return .black
        } else {
            return .white
        }
    }
}

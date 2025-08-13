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
    
    private let underlineWidth: CGFloat = 10
    private let underlineHeight: CGFloat = 1.5
    
    private var dayNumber: Int {
        Calendar.current.component(.day, from: date)
    }
    
    private var isToday: Bool {
        Calendar.current.isDateInToday(date)
    }
    
    private var isSelected: Bool {
        guard let selectedDate = selectedDate else { return false }
        return Calendar.current.isDate(date, inSameDayAs: selectedDate)
    }
    
    private var isCurrentMonth: Bool {
        Calendar.current.isDate(date, equalTo: currentMonth, toGranularity: .month)
    }
    
    private var isEnabled: Bool {
        return hasEvent && isCurrentMonth
    }
    
    var body: some View {
        ZStack {
            // 선택된 날짜 배경
            if isSelected {
                Image.iconSelectedDay
                    .resizable()
                    .aspectRatio(contentMode: .fit)
                    .frame(width: 36, height: 36)
                    .zIndex(0)
            }
            
            VStack(spacing: 0) {
                // 날짜 숫자(고정)
                Text("\(dayNumber)")
                    .pretendard(style: .body3)
                    .foregroundColor(textColor)
                    .padding(.top, 8)
                
                Spacer(minLength: 0)
                
                // 언더라인
                if hasEvent && isCurrentMonth {
                    Rectangle()
                        .fill(underlineColor)
                        .frame(width: underlineWidth, height: underlineHeight)
                        .padding(.bottom, 10)
                } else {
                    Spacer()
                        .frame(height: 10)
                }
            }
        }
        .frame(width: 36, height: 36 , alignment: .top)
        .contentShape(Rectangle())
        .onTapGesture {
            if isEnabled {
                onDateSelected(date)
            }
        }
    }
    
    private var textColor: Color {
        if !isCurrentMonth {
            return .grey4
        } else if !hasEvent {
            return .grey4
        } else if isSelected {
            return .black
        } else {
            return .white
        }
    }
    
    private var underlineColor: Color {
        isSelected ? .black : .point1
    }
}

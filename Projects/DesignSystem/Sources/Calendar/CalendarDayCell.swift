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
                    .padding(.top, 11)
                
                // 이벤트 dot(고정)
                if hasEvent && isCurrentMonth {
                    Circle()
                        .fill(dotColor)
                        .frame(width: 4, height: 4)
                        .offset(y: -2)
                    
                } else {
                    Spacer()
                        .frame(width: 4, height: 4)
                }
                Spacer()
            }
        }
        .frame(width: 36, height: 36 , alignment: .top)
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
        } else if isSelected {
            return .black
        } else {
            return .white
        }
    }
    
    private var dotColor: Color {
        if isSelected {
            return .black
        } else {
            return .clear
        }
    }
}

#Preview {
    CalendarDayCell(
        date: Date(), // 오늘 날짜
        currentMonth: Date(), // 현재 월
        selectedDate: Date(), // 선택된 날짜도 오늘
        hasEvent: true, // 이벤트 있음
        onDateSelected: { date in
            print("Selected: \(date)")
        }
    )
    .padding()
    .background(Color.black)
}

//
//  CalendarDayCell.swift
//  DesignSystem
//
//  Created by 이다영 on 6/28/25.
//  Copyright © 2025 Darayo. All rights reserved.
//

import SwiftUI
import DesignSystem
import Domain

struct CalendarDayCell: View {
    let date: Date
    let currentMonth: Date
    let selectedDate: Date?
    let events: [CalendarEvent]
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
    
    private var hasEvent: Bool {
        return !events.isEmpty && isCurrentMonth
    }
    
    private var isEnabled: Bool {
        return hasEvent
    }
    
    private var selectedBackgroundImage: Image? {
        guard isSelected, hasEvent else { return nil }
        switch events.first?.category {
        case .festivalDay:
            return Image.iconSelectedDay
        case .reservationDay:
            return Image.iconReservationDay
        case .none:
            return nil
        }
    }
    
    private var underlineColor: Color {
        if isSelected {
            return .black
        }
        
        if let firstEvent = events.first {
            switch firstEvent.category {
            case .festivalDay:
                return .point1
            case .reservationDay:
                return .point2
            }
        }
        return .point1
    }
    
    var body: some View {
        ZStack {
            // 선택된 날짜 배경
            if let selectedBackgroundImage {
                selectedBackgroundImage
                    .resizable()
                    .aspectRatio(contentMode: .fit)
                    .frame(width: 36, height: 36)
                    .zIndex(0)
            }
            
            VStack(spacing: 0) {
                Text("\(dayNumber)")
                    .pretendard(style: .body3)
                    .foregroundColor(textColor)
                    .padding(.top, 8)
                
                Spacer(minLength: 0)
                
                // 언더라인
                if hasEvent {
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
}

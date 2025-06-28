//
//  CalendarDemoView.swift
//  DesignSystemDemo
//
//  Created by 이다영 on 6/26/25.
//  Copyright © 2025 Darayo. All rights reserved.
//

import SwiftUI
import DesignSystem

struct CalendarDemoView: View {
    @State private var selectedDate: Date? = Date()
    @State private var calendar: CalendarModel = CalendarModel(events: DummyEventData.events)
    @State private var showCalendarView = false

    var body: some View {
        NavigationView {
            VStack(spacing: 0) {
                calendarSection
                Spacer()
                    .frame(height: 20)
                
                eventListSection
            }
            .background(Color.black)
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    HStack(spacing: 10) {
                        Button(action: {
                            // 왼쪽 버튼 액션 (빈 상태)
                        }) {
                            Image(systemName: "square.grid.2x2.fill")
                                .foregroundColor(.white)
                                .pretendard(style: .title3)
                        }
                        
                        Button(action: {
                            showCalendarView.toggle()
                        }) {
                            // 수정필요
                            Image(systemName: "list.bullet")
                                .foregroundColor(.white)
                                .pretendard(style: .title3)
                        }
                    }
                }
            }
        }
    }
    
    private var calendarSection: some View {
        CalendarView(
            calendar: calendar,
            onDateSelected: { date in
                selectedDate = date
            },
            onMonthChanged: { month in
                // 월이 변경될 때 필요한 로직
            }
        )
    }
    
    private var eventListSection: some View {
        VStack(spacing: 0) {
                EventListView(
                    events: eventsForSelectedDate,
                    title: "좋아요한 페스티벌"
                )
        }
    }
    
    private var emptyStateView: some View {
        VStack(spacing: 16) {
            Image(systemName: "calendar.circle")
                .font(.system(size: 18))
                .foregroundColor(.grey4)
                .padding(2)
                .frame(width: 24, height: 24, alignment: .center)
            
            Text("선택한 날짜에 등록된 이벤트가 없습니다")
                .pretendard(style: .body3)
                .foregroundColor(.grey3)
                .multilineTextAlignment(.center)
        }
        .frame(maxWidth: .infinity)
        .padding(.horizontal, 40)
        .padding(.vertical, 40)
    }
    
    private var eventsForSelectedDate: [CalendarModel.Event] {
        guard let selectedDate = selectedDate else { return [] }
        return calendar.events.filter { event in
            Foundation.Calendar.current.isDate(event.date, inSameDayAs: selectedDate)
        }
    }
}

#Preview {
    CalendarDemoView()
}


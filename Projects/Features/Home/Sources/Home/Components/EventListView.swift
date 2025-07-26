//
//  EventListView.swift
//  DesignSystem
//
//  Created by 이다영 on 6/26/25.
//  Copyright © 2025 Darayo. All rights reserved.
//

import SwiftUI
import DesignSystem

public struct EventListView: View {
    let events: [CalendarModel.Event]
    let allEvents: [CalendarModel.Event] // 전체 좋아요 한 페스티벌
    let title: String
    let isFiltered: Bool // 외부에서 받은 필터 상태
    let onTap: (CalendarModel.Event) -> Void
    let onToggleFilter: () -> Void // 토글 액션 전달
    
//    @State private var isSelected: Bool = false
    
    public init(
        events: [CalendarModel.Event],
        allEvents: [CalendarModel.Event],
        title: String = "좋아요한 페스티벌",
        isFiltered: Bool,
        onTap: @escaping (CalendarModel.Event) -> Void,
        onToggleFilter: @escaping () -> Void = {}
    ) {
        self.events = events
        self.allEvents = allEvents
        self.title = title
        self.isFiltered = isFiltered
        self.onTap = onTap
        self.onToggleFilter = onToggleFilter
    }
    
    public var body: some View {
        VStack(alignment: .leading, spacing: 0) {
            header
            
            ZStack {
                LazyVStack(spacing: 14) {
                    ForEach(currentEvents, id: \.id) { event in
                        EventCard(event: event)
                            .onTapGesture {
                                onTap(event)
                            }
                    }
                }
                .padding(.horizontal, 16)
                .opacity(currentEvents.isEmpty ? 0 : 1)
                .overlay(
                    Group {
                        if currentEvents.isEmpty {
                            emptyStateView
                        }
                    }
                )
            }
            .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .top)
            .animation(.easeInOut(duration: 0.2), value: isFiltered)
        }
        .padding(.bottom, 40)
        .background(Color.background1)
    }
    
    private var currentEvents: [CalendarModel.Event] {
        isFiltered ? allEvents : events
    }
}

private extension EventListView {
    var header: some View {
        Button(action: {
            onToggleFilter()
        }) {
            HStack(spacing: 5) {
                let icon: Image = isFiltered ? Image.iconChecked : Image.iconUnchecked

                icon
                    .resizable()
                    .frame(width: 24, height: 24)
                
                Text(title)
                    .pretendard(style: .body4)
                    .foregroundColor(.grey3)
                
                Spacer()
            }
        }
        .padding(.vertical, 12)
        .padding(.horizontal, 16)
        .contentShape(Rectangle())
    }
    
    // MARK: - 안내 멘트 출력
    var emptyStateView: some View {
        VStack(spacing: 10) {
            Rectangle().fill(Color.clear).frame(height: 400)
            
            if isFiltered && allEvents.isEmpty {
                // 좋아요한것 체크 했는데 좋아요 기록이 없음
                Text("아직 좋아요한 페스티벌이 없어요!")
                    .pretendard(style: .title3)
                    .foregroundColor(.white)
                    .multilineTextAlignment(.center)
                
                Text("관심있는 페스티벌을 좋아요하고,\n소식을 받아보세요 :)")
                    .pretendard(style: .body4)
                    .foregroundColor(.grey3)
                    .multilineTextAlignment(.center)
            } else {
                // 그 외엔 날짜에 일정 없음
                Text("선택한 날짜에 페스티벌 일정이 없어요")
                    .pretendard(style: .title3)
                    .foregroundColor(.grey4)
                    .multilineTextAlignment(.center)
            }
            
            Rectangle().fill(Color.clear).frame(minHeight: 200)
        }
        .frame(maxWidth: .infinity)
        .frame(maxHeight: .infinity)
    }
}

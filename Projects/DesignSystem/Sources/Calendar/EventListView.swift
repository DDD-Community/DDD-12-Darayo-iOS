//
//  EventListView.swift
//  DesignSystem
//
//  Created by 이다영 on 6/26/25.
//  Copyright © 2025 Darayo. All rights reserved.
//

import SwiftUI

public struct EventListView: View {
    let events: [CalendarModel.Event]
    let title: String
    
    @State private var isSelected: Bool = false
    
    public init(
        events: [CalendarModel.Event],
        title: String = "좋아요한 페스티벌",
        icon: String = "checkmark.square"
    ) {
        self.events = events
        self.title = title
    }
    
    public var body: some View {
        VStack(alignment: .leading, spacing: 0) {
            header
            
            ZStack {
                if isSelected || events.isEmpty {
                    emptyStateView
                        .opacity(isSelected || events.isEmpty ? 1 : 0)
                } else {
                    LazyVStack(spacing: 14) {
                        ForEach(events, id: \.id) { event in
                            EventCard(event: event)
                        }
                    }
                    .padding(.horizontal, 16)
                    .opacity(isSelected || events.isEmpty ? 0 : 1)
                }
            }
            .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .top)
            .animation(.easeInOut(duration: 0.2), value: isSelected)
        }
        .padding(.bottom, 40)
        .background(Color.background1)
    }
}

private extension EventListView {
    var header: some View {
        Button(action: {
            isSelected.toggle()
        }) {
            HStack(spacing: 5) {
                Image(systemName: isSelected ? "checkmark.circle.fill" : "circle")
                    .resizable()
                    .frame(width: 18, height: 18)
                    .foregroundColor(isSelected ? .white : .grey3)
                
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
    
    var emptyStateView: some View {
        VStack(spacing: 8) {
            Text("아직 좋아요한 페스티벌이 없어요!")
                .pretendard(style: .body3)
                .foregroundColor(.grey3)
                .multilineTextAlignment(.center)
            
            Text("관심있는 페스티벌을 좋아요하고,\n소식을 받아보세요 :)")
                .pretendard(style: .caption1)
                .foregroundColor(.grey4)
                .multilineTextAlignment(.center)
        }
        .frame(maxWidth: .infinity)
        .padding(.vertical, 40)
    }
}


//#Preview {
//    EventListView(
//        events: [
//            CalendarModel.Event(
//                id: UUID().uuidString,
//                title: "인천 펜타포트 락 페스티벌",
//                location: "인터파크",
//                date: Date(),
//                time: "25.06.12 18:00",
//                category: .reservationDay
//            ),
//            CalendarModel.Event(
//                id: UUID().uuidString,
//                title: "서울 재즈 페스티벌",
//                location: "예스24",
//                date: Date(),
//                time: "25.07.20 19:30",
//                category: .festivalDay
//            )
//        ],
//        title: "좋아요한 페스티벌"
//    )
//}

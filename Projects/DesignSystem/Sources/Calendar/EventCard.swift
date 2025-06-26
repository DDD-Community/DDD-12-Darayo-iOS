//
//  EventCard.swift
//  DesignSystem
//
//  Created by 이다영 on 6/26/25.
//  Copyright © 2025 Darayo. All rights reserved.
//

import SwiftUI

public struct EventCard: View {
    let event: CalendarModel.Event
    
    public init(event: CalendarModel.Event) {
        self.event = event
    }
    
    public var body: some View {
        HStack(spacing: 12) {
            
            // 이벤트 이미지 플레이스홀더
            RoundedRectangle(cornerRadius: 8)
                .fill(Color.blue.opacity(0.3))
                .frame(width: 60, height: 60)
                .overlay(
                    Image(systemName: "music.note")
                        .foregroundColor(.white)
                        .font(.title2)
                )
            
            VStack(alignment: .leading, spacing: 4) {
                HStack {
                    Text(event.category.label)
                        .pretendard(style: .caption2)
                        .foregroundColor(event.category.textColor)
                        .padding(.horizontal, 8)
                        .frame(width: 47, height: 16)
                        .background(event.category.backgroundColor)
                        .cornerRadius(16)
                    
                    Spacer()
                }
                
                Text(event.title)
                    .pretendard(style: .title3)
                    .foregroundColor(.white)
                    .lineLimit(1)
                
                HStack {
                    Text("예매처")
                        .pretendard(style: .body3)
                        .foregroundColor(.grey4)
                    Text("\(event.location)")
                        .pretendard(style: .body3)
                        .foregroundColor(.grey3)
                        .lineLimit(1)
                }
                
                HStack {
                    Text("예매일시")
                        .pretendard(style: .body3)
                        .foregroundColor(.grey4)
                    Text("\(event.time)")
                        .pretendard(style: .body3)
                        .foregroundColor(.gray)
                }
            }
            Spacer()
        }
        .padding(12)
        .background(Color.gray.opacity(0.1))
        .cornerRadius(12)
    }
}
    
    // MARK: - Category 색상 로직

    public enum EventCategory {
        case reservationDay
        case festivalDay
        
        public var label: String {
            switch self {
            case .reservationDay:
                return "예매일"
            case .festivalDay:
                return "행사일"
            }
        }
        
        public var textColor: Color {
            switch self {
            case .reservationDay:
                return .point3
            case .festivalDay:
                return .point1
            }
        }
        
        public var backgroundColor: Color {
            switch self {
            default: Color.grey6
        }
    }
}

#Preview {
    EventCard(event: CalendarModel.Event(
        title: "페스티벌 A",
        location: "인터파크",
        date: Date(),
        time: "25.06.12 18:00",
        category: .festivalDay
    ))
    .background(Color.black)
}

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
        eventCard(event: event)
    }
    
    private func eventCard(event: CalendarModel.Event) -> some View {
        HStack(spacing: 0) {
            ZStack {
                ImageView(
                    event.posterURL,
                    placeholder: .placeholder3
                )
                .scaledToFill()
                
                LinearGradient(
                    gradient: .init(
                        colors: [
                            .black.opacity(0.5),
                            .black.opacity(0)
                        ]
                    ),
                    startPoint: .top,
                    endPoint: .bottom
                )
            }
            .frame(width: 108, height: 108)
            .clipped()
            
            VStack(alignment: .leading, spacing: 8) {
                VStack(alignment: .leading, spacing: 4) {
                    Text(event.category.label)
                        .pretendard(style: .caption2)
                        .foregroundColor(event.category.textColor)
                        .frame(width: 47, height: 16)
                        .background(event.category.backgroundColor)
                        .clipShape(RoundedRectangle(cornerRadius: 16))
                    
                    Text(event.title)
                        .pretendard(style: .title3)
                        .foregroundColor(.white)
                        .lineLimit(1)
                }
                .frame(maxWidth: .infinity, alignment: .topLeading)
                
                infoSection(for: event)
            }
            .padding(.horizontal, 12)
            .frame(maxWidth: .infinity, alignment: .top)
            
            Spacer()
        }
        .background(Color.background2)
        .clipShape(RoundedRectangle(cornerRadius: 4))
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

@ViewBuilder
private func infoSection(for event: CalendarModel.Event) -> some View {
    VStack(alignment: .leading, spacing: 0) {
        infoRow(label: event.category == .reservationDay ? "예매처" : "장소",
                value: event.location)

        infoRow(label: event.category == .reservationDay ? "예매일시" : "행사일",
                value: event.time)
    }
}

private func infoRow(label: String, value: String) -> some View {
    HStack(spacing: 6) {
        Text(label)
            .pretendard(style: .body4)
            .foregroundColor(.grey4)

        Text(value)
            .pretendard(style: .body4)
            .foregroundColor(.grey3)
            .lineLimit(1)
    }
}


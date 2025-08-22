//
//  EventCard.swift
//  DesignSystem
//
//  Created by 이다영 on 6/26/25.
//  Copyright © 2025 Darayo. All rights reserved.
//

import SwiftUI
import Domain
import DesignSystem

public struct EventCard: View {
    let event: CalendarEvent
    
    public init(event: CalendarEvent) {
        self.event = event
    }
    
    public var body: some View {
        eventCard(event: event)
    }
    
    private func eventCard(event: CalendarEvent) -> some View {
        HStack(spacing: 0) {
            ZStack {
                ImageView(
                    event.posterURL,
                    placeholder: .placeholder3
                )
                
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
                        .foregroundColor(textColor(for: event.category))
                        .frame(width: 47, height: 16)
                        .background(backgroundColor(for: event.category))
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
    
    // MARK: - Category 색상 로직
    private func textColor(for category: EventCategory) -> Color {
        switch category {
        case .reservationDay:
            return .point3
        case .festivalDay:
            return .point1
        }
    }
        
    private func backgroundColor(for category: EventCategory) -> Color {
        return .grey6
    }
}

@ViewBuilder
private func infoSection(for event: CalendarEvent) -> some View {
    VStack(alignment: .leading, spacing: 0) {
        switch event.category {
        case .festivalDay:
            // 행사일: 장소 → Image.location, 행사일 → Image.eventDay (둘 다 point1)
            iconRow(icon: Image.iconLocation, tint: .point1, value: event.location)
            iconRow(icon: Image.iconEventDay, tint: .point1, value: event.time)
            
        case .reservationDay:
            // 예매일: 예매처 → Image.pointer, 예매일시 → Image.point (둘 다 point2)
            iconRow(icon: Image.iconPointer, tint: .point2, value: event.location)
            iconRow(icon: Image.iconTime,   tint: .point2, value: event.time)
        }
    }
}

private func iconRow(icon: Image, tint: Color, value: String) -> some View {
    HStack(spacing: 6) {
        icon
            .renderingMode(.template)
            .resizable()
            .aspectRatio(contentMode: .fit)
            .frame(width: 14, height: 14)
            .foregroundColor(tint)

        Text(value)
            .pretendard(style: .body4)
            .foregroundColor(.grey3)
            .lineLimit(1)
    }
}


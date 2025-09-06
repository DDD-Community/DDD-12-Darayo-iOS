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
            .frame(width: 108, height: 95)
            .clipped()
            
            VStack(alignment: .leading, spacing: 8) {
                VStack(alignment: .leading, spacing: 4) {
                    Text(event.title)
                        .pretendard(style: .title4)
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
    VStack(alignment: .leading, spacing: 2) {
        switch event.category {
        case .festivalDay:
            iconRow(icon: Image.iconLocation, tint: .point1, value: event.location) // 행사 장소
            iconRow(icon: Image.iconEventDay, tint: .point1, value: event.time) // 행사 일시
            
        case .reservationDay:
            iconRow(icon: Image.iconPointer, tint: .point2, value: event.location) // 예매처
            iconRow(icon: Image.iconTime,   tint: .point2, value: event.time) // 예매 일시
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


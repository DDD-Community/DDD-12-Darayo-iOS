//
//  EventCard.swift
//  DesignSystem
//
//  Created by 이다영 on 6/26/25.
//  Copyright © 2025 Darayo. All rights reserved.
//

import SwiftUI

public struct EventCard: View {
    let event: CalendarModel.Event?
    let isLoading: Bool
    
    public init(event: CalendarModel.Event?, isLoading: Bool = false) {
        self.event = event
        self.isLoading = isLoading
    }
    
    public var body: some View {
        if isLoading {
            shimmerCard
        } else if let event {
            eventCard(event: event)
        }
    }
    
    private var shimmerCard: some View {
        ShimmerView()
            .frame(height: 108)
            .clipShape(RoundedRectangle(cornerRadius: 4))
    }
    
    private func eventCard(event: CalendarModel.Event) -> some View {
        HStack(spacing: 0) {
            ZStack {
                if let url = event.posterURL {
                    AsyncImage(url: url) { phase in
                        if let image = phase.image {
                            image
                                .resizable()
                                .scaledToFill()
                        } else {
                            Color.grey4
                        }
                    }
                } else {
                    Color.grey4
                }
            }
            .frame(width: 108, height: 108)
            .clipped()
            .overlay(gradientOverlay)
            
            VStack(alignment: .leading, spacing: 8) {
                VStack(alignment: .leading, spacing: 4) {
                    HStack(alignment: .center) {
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
                }
                .frame(maxWidth: .infinity, alignment: .topLeading)
                
                VStack(alignment: .leading, spacing: 0) {
                    HStack(spacing: 6) {
                        Text("예매처")
                            .pretendard(style: .body4)
                            .foregroundColor(.grey4)
                        Text("\(event.location)")
                            .pretendard(style: .body4)
                            .foregroundColor(.grey3)
                            .lineLimit(1)
                    }
                    
                    HStack(spacing: 6) {
                        Text("예매일시")
                            .pretendard(style: .body4)
                            .foregroundColor(.grey4)
                        Text("\(event.time)")
                            .pretendard(style: .body4)
                            .foregroundColor(.gray)
                    }
                }
            }
            .padding(.horizontal, 12)
            .frame(maxWidth: .infinity, alignment: .top)
            
            Spacer()
        }
        .background(Color.background2)
        .cornerRadius(4)
    }
    
    // MARK: - 포스터 이미지 그림자
    private var gradientOverlay: some View {
        LinearGradient(
            stops: [
                .init(color: .black.opacity(0.2), location: 0.0),
                .init(color: .black.opacity(0.05), location: 0.15),
                .init(color: .clear, location: 0.3)
            ],
            startPoint: .top,
            endPoint: .bottom
        )
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

//#Preview {
//    VStack(spacing: 16) {
//        // 실제 데이터가 있을 때
//        EventCard(event: CalendarModel.Event(
//            title: "페스티벌 A",
//            location: "인터파크",
//            date: Date(),
//            time: "25.06.12 18:00",
//            category: .festivalDay
//        ), isLoading: false)
//        
//        // 로딩 중일 때
//        EventCard(event: nil, isLoading: true)
//    }
//    .padding()
//    .background(Color.black)
//}

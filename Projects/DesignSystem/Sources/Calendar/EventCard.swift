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
                    Text(event.category)
                        .font(.caption)
                        .foregroundColor(.blue)
                        .padding(.horizontal, 8)
                        .padding(.vertical, 2)
                        .background(Color.blue.opacity(0.2))
                        .cornerRadius(4)
                    
                    Spacer()
                }
                
                Text(event.title)
                    .pretendard(style: .title4)
                    .foregroundColor(.white)
                    .lineLimit(1)
                
                Text(event.location)
                    .pretendard(style: .body2)
                    .foregroundColor(.gray)
                    .lineLimit(1)
                
                Text(event.time)
                    .pretendard(style: .body2)
                    .foregroundColor(.gray)
            }
            
            Spacer()
        }
        .padding(12)
        .background(Color.gray.opacity(0.1))
        .cornerRadius(12)
    }
}

#Preview {
    EventCard(event: CalendarModel.Event(
        title: "페스티벌 A",
        location: "서울 올림픽공원",
        date: Date(),
        time: "18:00",
        category: "예매일"
    ))
    .background(Color.black)
}

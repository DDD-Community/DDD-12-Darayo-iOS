//
//  EventListView.swift
//  DesignSystem
//
//  Created by 이다영 on 6/26/25.
//  Copyright © 2025 Darayo. All rights reserved.
//

import SwiftUI
import Domain

public struct EventListView: View {
    public let events: [CalendarEvent]
    public let title: String?
    public let onTap: (CalendarEvent) -> Void

    public init(
        events: [CalendarEvent],
        title: String? = nil,
        onTap: @escaping (CalendarEvent) -> Void
    ) {
        self.events = events
        self.title = title
        self.onTap = onTap
    }

    public var body: some View {
        VStack(alignment: .leading, spacing: 0) {
            if let title {
                // 간단 헤더 (토글 제거)
                HStack(spacing: 8) {
                    Text(title)
                        .pretendard(style: .body4)
                        .foregroundColor(.grey3)
                    Spacer()
                }
                .padding(.vertical, 12)
                .padding(.horizontal, 16)
            }

            ZStack {
                LazyVStack(spacing: 14) {
                    ForEach(events, id: \.id) { event in
                        EventCard(event: event)
                            .onTapGesture { onTap(event) }
                    }
                }
                .padding(.horizontal, 16)
                .opacity(events.isEmpty ? 0 : 1)
            }
            .frame(maxWidth: .infinity, alignment: .top)
        }
        .padding(.bottom, 40)
        .background(Color.background1)
    }
}

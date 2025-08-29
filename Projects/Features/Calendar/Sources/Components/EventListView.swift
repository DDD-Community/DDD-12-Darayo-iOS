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
    public let onTap: (CalendarEvent) -> Void

    public init(
        events: [CalendarEvent],
        onTap: @escaping (CalendarEvent) -> Void
    ) {
        self.events = events
        self.onTap = onTap
    }

    public var body: some View {
                LazyVStack(spacing: 14) {
                    ForEach(events, id: \.id) { event in
                        EventCard(event: event)
                            .onTapGesture { onTap(event) }
                    }
                }
                .padding(.horizontal, 16)
    }
}

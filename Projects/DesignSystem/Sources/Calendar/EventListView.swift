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
    let icon: String
    
    public init(
        events: [CalendarModel.Event],
        title: String = "좋아요한 페스티벌",
        icon: String = "checkmark.square"
    ) {
        self.events = events
        self.title = title
        self.icon = icon
    }
    
    public var body: some View {
        VStack(alignment: .leading, spacing: 0) {
            header
            
            if !events.isEmpty {
                eventList
            }
        }
        .background(Color.black)
    }
}

private extension EventListView {
    var header: some View {
        HStack {
            Image(systemName: icon)
                .foregroundColor(.white)
            
            Text(title)
                .font(.system(size: 16, weight: .medium))
                .foregroundColor(.white)
            
            Spacer()
        }
        .padding(.horizontal, 20)
        .padding(.vertical, 16)
    }
    
    var eventList: some View {
        ScrollView {
            LazyVStack(spacing: 12) {
                ForEach(events, id: \.id) { event in
                    EventCard(event: event)
                }
            }
            .padding(.horizontal, 20)
        }
    }
}

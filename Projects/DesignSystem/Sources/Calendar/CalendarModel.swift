//
//  Calendar.swift
//  DesignSystem
//
//  Created by 이다영 on 6/26/25.
//  Copyright © 2025 Darayo. All rights reserved.
//

import Foundation

public struct CalendarModel {
    public let events: [Event]
    
    public init(events: [Event]) {
        self.events = events
    }
}

extension CalendarModel {
    public struct Event {
        public let id: String
        public let title: String
        public let location: String
        public let date: Date
        public let time: String
        public let category: String
        
        public init(
            id: String = UUID().uuidString,
            title: String,
            location: String,
            date: Date,
            time: String,
            category: String
        ) {
            self.id = id
            self.title = title
            self.location = location
            self.date = date
            self.time = time
            self.category = category
        }
    }
}

public struct CalendarHelper {
    public static func numberOfDays(in date: Date) -> Int {
        Foundation.Calendar.current.range(of: .day, in: .month, for: date)?.count ?? 0
    }

    public static func firstWeekdayOfMonth(in date: Date) -> Int {
        let components = Foundation.Calendar.current.dateComponents([.year, .month], from: date)
        let firstDay = Foundation.Calendar.current.date(from: components)!
        return Foundation.Calendar.current.component(.weekday, from: firstDay)
    }
    
    public static func firstDateOfMonth(_ date: Date) -> Date {
        let components = Foundation.Calendar.current.dateComponents([.year, .month], from: date)
        return Foundation.Calendar.current.date(from: components)!
    }

    public static func date(at index: Int, in month: Date) -> Date {
        let calendar = Foundation.Calendar.current
        let components = calendar.dateComponents([.year, .month], from: month)
        guard let firstDay = calendar.date(from: components) else { return Date() }

        return calendar.date(byAdding: .day, value: index, to: firstDay) ?? Date()
    }
}

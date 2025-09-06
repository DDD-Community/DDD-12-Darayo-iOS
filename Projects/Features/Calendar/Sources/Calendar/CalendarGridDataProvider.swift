//
//  CalendarGridDataProvider.swift
//  DesignSystem
//
//  Created by 이다영 on 7/3/25.
//  Copyright © 2025 Darayo. All rights reserved.
//

import Foundation
import SwiftUI

struct CalendarGridDataProvider {
    static func makeCalendarDates(for month: Date) -> [Date] {
        let calendar = Calendar.current
        guard let startOfMonth = calendar.dateInterval(of: .month, for: month)?.start else { return [] }

        let weekday = calendar.component(.weekday, from: startOfMonth)
        let daysFromMonday = (weekday + 5) % 7
        let startOfCalendar = calendar.date(byAdding: .day, value: -daysFromMonday, to: startOfMonth)!

        var dates: [Date] = []
        var current = startOfCalendar

        for _ in 0..<42 {
            dates.append(current)
            current = calendar.date(byAdding: .day, value: 1, to: current)!
        }

        return dates
    }
}

enum CalendarLayout {
    static let columns: [GridItem] =
        Array(repeating: GridItem(.flexible(), spacing: 0), count: 7)
}

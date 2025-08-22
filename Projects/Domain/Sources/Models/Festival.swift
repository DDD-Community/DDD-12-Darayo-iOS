//
//  Festival.swift
//  Domain
//
//  Created by 이정원 on 6/24/25.
//  Copyright © 2025 Darayo. All rights reserved.
//

import Foundation
import Util

public struct Festival: Equatable, Hashable {
    public let id: Int
    public let name: String
    public let startDate: Date?
    public let endDate: Date?
    public let placeName: String
    public let posterURLString: String
    public let regulation: String
    public let artists: [Artist]
    public let transportationInfo: String
    public let remark: String
    public let reservations: [Reservation]
    public let urlInfos: [URLInfo]
    
    // TODO: need to refactor
    public var isNotificationEnabled: Bool
    
    public init(
        id: Int,
        name: String,
        startDate: Date?,
        endDate: Date?,
        placeName: String,
        posterURLString: String,
        regulation: String,
        artists: [Artist],
        transportationInfo: String,
        remark: String,
        reservations: [Reservation],
        urlInfos: [URLInfo],
        isNotificationEnabled: Bool = true
    ) {
        self.id = id
        self.name = name
        self.startDate = startDate
        self.endDate = endDate
        self.placeName = placeName
        self.posterURLString = posterURLString
        self.regulation = regulation
        self.artists = artists
        self.transportationInfo = transportationInfo
        self.remark = remark
        self.reservations = reservations
        self.urlInfos = urlInfos
        self.isNotificationEnabled = isNotificationEnabled
    }
}

public extension Festival {
    var dateString: String {
        let start = startDate?.toString(dateFormat: .home)
        let end = endDate?.toString(dateFormat: .home)
        guard let start, let end else { return "" }
        return "\(start)-\(end)"
    }
    
    var posterURL: URL? {
        URL(string: posterURLString)
    }
    
    var purchaseDates: [[Date]] {
        let dates: [[Date]] = reservations.compactMap {
            let open = $0.openDateTime?.startOfDay
            let close = $0.closeDateTime?.startOfDay
            guard let open, let close else { return nil }
            return [open, close]
        }
        
        return Array(Set(dates)).sorted { lhs, rhs in
            guard lhs[0] == rhs[0] else { return lhs[0] < rhs[0] }
            return lhs[1] < rhs[1]
        }
    }
    
    var vendors: [Vendor] {
        reservations.map { $0.vendor }
    }
}

public struct CalendarEvent {
    public let id: String
    public let festivalId: Int
    public let title: String
    public let location: String
    public let date: Date
    public let endDate: Date?
    public let time: String
    public let category: EventCategory
    public let posterURL: URL?
    
    public init(
        id: String = UUID().uuidString,
        festivalId: Int,
        title: String,
        location: String,
        date: Date,
        endDate: Date? = nil,
        time: String,
        category: EventCategory,
        posterURL: URL? = nil
    ) {
        self.id = id
        self.festivalId = festivalId
        self.title = title
        self.location = location
        self.date = date
        self.endDate = endDate
        self.time = time
        self.category = category
        self.posterURL = posterURL
    }
}

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
}

// Festival -> CalendarEvent 변환 헬퍼
public extension Festival {
    func toCalendarEvents() -> [CalendarEvent] {
        var events: [CalendarEvent] = []
        let vendorNamesArray = reservations.compactMap { $0.vendor.name }
        let vendorNames: String
        
        // category: 예매일
        if let openDate = reservations.first?.openDateTime {
            if vendorNamesArray.count > 3 {
                    let firstTwo = vendorNamesArray.prefix(3).joined(separator: ", ")
                    let remainingCount = vendorNamesArray.count - 3
                    vendorNames = "\(firstTwo) +\(remainingCount)"
            } else {
                vendorNames = vendorNamesArray.joined(separator: ", ")
            }
            
            events.append(CalendarEvent(
                id: UUID().uuidString,
                festivalId: id,
                title: name,
                location: vendorNames,
                date: openDate,
                time: openDate.toString(dateFormat: .reservateionDateTime),
                category: .reservationDay,
                posterURL: URL(string: posterURLString)
            ))
        }
        
        // category: 행사일
        if let startDate = startDate, let endDate = endDate {
            var currentDate = startDate
            let calendar = Calendar.current
            
            while currentDate <= endDate {
                events.append(CalendarEvent(
                    id: UUID().uuidString,
                    festivalId: id,
                    title: name,
                    location: placeName,
                    date: currentDate,
                    endDate: endDate,
                    time: "\(startDate.toString(dateFormat: .eventDate)) - \(endDate.toString(dateFormat: .eventDate))",
                    category: .festivalDay,
                    posterURL: URL(string: posterURLString)
                ))
                guard let nextDay = calendar.date(byAdding: .day, value: 1, to: currentDate) else { break }
                currentDate = nextDay
            }
        }
        
        return events
    }
}

public func makeCalendarEvents(from festivals: [Festival]) -> [CalendarEvent] {
    festivals.flatMap { $0.toCalendarEvents() }
}

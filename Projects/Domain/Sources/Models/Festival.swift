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

//
//  Festival.swift
//  Domain
//
//  Created by 이정원 on 6/24/25.
//  Copyright © 2025 Darayo. All rights reserved.
//

import Foundation
import Util

public struct Festival: Hashable {
    public let id: Int
    public let name: String
    public let startDate: Date?
    public let endDate: Date?
    public let placeName: String
    public let posterURLString: String
    public var isNotificationEnabled: Bool
    
    public init(
        id: Int,
        name: String,
        startDate: Date?,
        endDate: Date?,
        placeName: String,
        posterURLString: String,
        isNotificationEnabled: Bool = true
    ) {
        self.id = id
        self.name = name
        self.startDate = startDate
        self.endDate = endDate
        self.placeName = placeName
        self.posterURLString = posterURLString
        self.isNotificationEnabled = isNotificationEnabled
    }
    
    public var dateString: String {
        let start = startDate?.toString(dateFormat: .home)
        let end = endDate?.toString(dateFormat: .home)
        guard let start, let end else { return "" }
        return "\(start)-\(end)"
    }
    
    public var posterURL: URL? {
        URL(string: posterURLString)
    }
}

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
    public let name: String
    public let startDate: Date?
    public let endDate: Date?
    public let placeName: String
    
    public init(
        name: String,
        startDate: Date?,
        endDate: Date?,
        placeName: String
    ) {
        self.name = name
        self.startDate = startDate
        self.endDate = endDate
        self.placeName = placeName
    }
    
    public var dateString: String {
        let start = startDate?.toString(dateFormat: .home)
        let end = endDate?.toString(dateFormat: .home)
        guard let start, let end else { return "" }
        return "\(start)-\(end)"
    }
}

//
//  Festival.swift
//  Domain
//
//  Created by 이정원 on 6/24/25.
//  Copyright © 2025 Darayo. All rights reserved.
//

public struct Festival: Hashable {
    public let title: String
    public let dateString: String
    public let place: String
    public var isNotificationEnabled: Bool

    
    public init(
        title: String,
        dateString: String,
        place: String,
        isNotificationEnabled: Bool = true
    ) {
        self.title = title
        self.dateString = dateString
        self.place = place
        self.isNotificationEnabled = isNotificationEnabled
    }
}

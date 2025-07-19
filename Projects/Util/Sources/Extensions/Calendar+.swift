//
//  Calendar+.swift
//  Util
//
//  Created by 이정원 on 7/19/25.
//  Copyright © 2025 Darayo. All rights reserved.
//

import Foundation

public extension Calendar {
    static var `default`: Self {
        var calendar = Calendar.current
        calendar.timeZone = TimeZone(identifier: "Asia/Seoul") ?? .current
        return calendar
    }
}

//
//  DateFormat.swift
//  Util
//
//  Created by 이정원 on 7/15/25.
//  Copyright © 2025 Darayo. All rights reserved.
//

public enum DateFormat {
    case festivalDate
    case home
    case performanceDate
    case reservation
    case festivalWithWeekday
    case reservationWithWeekday
    
    var value: String {
        switch self {
        case .festivalDate, .performanceDate:
            "yyyy-MM-dd"
        case .home: "yy.MM.dd"
        case .reservation: "yyyy-MM-dd'T'HH:mm:ss"
        case .festivalWithWeekday, .reservationWithWeekday:
            "yyyy. MM. dd (E)"
        }
    }
}

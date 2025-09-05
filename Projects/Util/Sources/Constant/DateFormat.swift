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
    case updateDate
    case updateDateString
    case festivalWithWeekday
    case reservationWithWeekday
    case eventDate
    case reservateionDateTime
    
    var value: String {
        switch self {
        case .festivalDate, .performanceDate:
            "yyyy-MM-dd"
        case .home: "yy.MM.dd"
        case .reservation, .updateDate:
            "yyyy-MM-dd'T'HH:mm:ss"
        case .updateDateString:
            "yyyy. MM. dd"
        case .festivalWithWeekday, .reservationWithWeekday:
            "yyyy. MM. dd (E)"
        case .eventDate: "yy.MM.dd" //calendarView 행사일 표시
        case .reservateionDateTime: "yy.MM.dd HH:mm"
        }
    }
}

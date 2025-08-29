//
//  CalendarMode.swift
//  Calendar
//
//  Created by 이다영 on 8/30/25.
//  Copyright © 2025 Darayo. All rights reserved.
//

import Foundation

public enum CalendarMode: Int, CaseIterable, Equatable {
    case eventDay = 0   // 행사일
    case reservationDay // 예매일

    public var title: String {
        switch self {
        case .eventDay: return "행사일"
        case .reservationDay: return "예매일"
        }
    }
}

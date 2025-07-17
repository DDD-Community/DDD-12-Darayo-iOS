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
    
    var value: String {
        switch self {
        case .festivalDate: "yyyy-MM-dd"
        case .home: "yy.MM.dd"
        case .performanceDate: "yyyy-MM-dd"
        case .reservation: "yyyy-MM-dd'T'HH:mm:ss"
        }
    }
}

//
//  Reservation.swift
//  Domain
//
//  Created by 이정원 on 7/18/25.
//  Copyright © 2025 Darayo. All rights reserved.
//

import Foundation

public struct Reservation: Equatable, Hashable {
    public let id: String
    public let openDateTime: Date?
    public let closeDateTime: Date?
    public let urlString: String
    public let type: ReservationType?
    public let remark: String
    
    public init(
        id: String,
        openDateTime: Date?,
        closeDateTime: Date?,
        urlString: String,
        type: ReservationType?,
        remark: String
    ) {
        self.id = id
        self.openDateTime = openDateTime
        self.closeDateTime = closeDateTime
        self.urlString = urlString
        self.type = type
        self.remark = remark
    }
}

public enum ReservationType {
    case general
    case earlyBird
    
    public init?(value: String?) {
        switch value {
        case "GENERAL": self = .general
        case "EARLY_BIRD": self = .earlyBird
        default: return nil
        }
    }
}

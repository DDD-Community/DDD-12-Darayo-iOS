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
    
    public var vendor: Vendor {
        let name: String = if urlString.contains("yes24.co") { "예스24" }
        else if urlString.contains("melon.co") { "멜론" }
        else if urlString.contains("ticketlink.co") { "티켓링크" }
        else if urlString.contains("interpark.co") { "인터파크" }
        else if urlString.contains("kream.co") { "KREAM" }
        else if urlString.contains("naver.co") { "네이버" }
        else if urlString.contains("29cm.co") { "29CM" }
        else { "기타" }
        
        return Vendor(name: name, urlString: urlString)
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

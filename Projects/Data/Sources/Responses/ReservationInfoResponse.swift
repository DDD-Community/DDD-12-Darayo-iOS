//
//  ReservationInfoResponse.swift
//  Data
//
//  Created by 이정원 on 7/18/25.
//  Copyright © 2025 Darayo. All rights reserved.
//

import Foundation
import Domain

struct ReservationInfoResponse: Decodable {
    let reservationInfoId: Int?
    let openDateTime: String?
    let closeDateTime: String?
    let ticketURL: String?
    let type: String?
    let remark: String?
}

extension ReservationInfoResponse {
    var toDomain: Reservation? {
        guard let reservationInfoId else { return nil }
        let openDateTime = openDateTime?.toDate(dateFormat: .reservation)
        let closeDateTime: Date? = switch closeDateTime?.contains("9999") {
        case true: Date.distantFuture
        case false: closeDateTime?.toDate(dateFormat: .reservation)
        default: nil
        }
        
        return Reservation(
            id: reservationInfoId.string,
            openDateTime: openDateTime,
            closeDateTime: closeDateTime,
            urlString: ticketURL ?? "",
            type: ReservationType(value: type),
            remark: remark ?? ""
        )
    }
}

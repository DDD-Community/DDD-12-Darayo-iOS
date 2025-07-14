//
//  FestivalResponse.swift
//  Data
//
//  Created by 이정원 on 7/14/25.
//  Copyright © 2025 Darayo. All rights reserved.
//

import Domain
import Util

struct FestivalResponse: Decodable {
    let festivalId: Int?
    let name: String?
    let placeName: String?
    let placeAddress: String?
    let startDate: String?
    let endDate: String?
    let posterUrl: String?
    let banGoods: String?
    let transportationInfo: String?
    let remark: String?
    let reservationInfos: [ReservationInfoResponse]?
    let artists: [ArtistResponse]?
    let urlInfos: [URLInfoResponse]?
}

struct ReservationInfoResponse: Decodable {
    let reservationInfoId: Int?
    let openDateTime: String?
    let closeDateTime: String?
    let ticketURL: String?
    let type: String?
    let remark: String?
}

struct ArtistResponse: Decodable {
    let artistId: Int?
    let artistDisplayName: String?
    let performanceDate: String?
}

struct URLInfoResponse: Decodable {
    let url: String?
    let type: String?
}

extension FestivalResponse {
    var toDomain: Festival {
        return .init(
            name: name ?? "",
            startDate: startDate?.toDate(dateFormat: .festivalDate),
            endDate: endDate?.toDate(dateFormat: .festivalDate),
            placeName: placeName ?? ""
        )
    }
}

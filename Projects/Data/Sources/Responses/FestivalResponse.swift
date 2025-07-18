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

extension FestivalResponse {
    var toDomain: Festival? {
        guard let festivalId else { return nil }
        return Festival(
            id: festivalId,
            name: name ?? "",
            startDate: startDate?.toDate(dateFormat: .festivalDate),
            endDate: endDate?.toDate(dateFormat: .festivalDate),
            placeName: placeName ?? "",
            posterURLString: posterUrl ?? "",
            regulation: banGoods ?? "",
            artists: artists?.compactMap { $0.toDomain } ?? [],
            transportationInfo: transportationInfo ?? "",
            remark: remark ?? "",
            reservations: reservationInfos?.compactMap { $0.toDomain } ?? [],
            urlInfos: urlInfos?.compactMap { $0.toDomain } ?? []
        )
    }
}

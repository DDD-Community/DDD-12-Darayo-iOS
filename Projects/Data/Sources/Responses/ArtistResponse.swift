//
//  ArtistResponse.swift
//  Data
//
//  Created by 이정원 on 7/17/25.
//  Copyright © 2025 Darayo. All rights reserved.
//

import Domain
import Util

struct ArtistResponse: Decodable {
    let artistId: Int?
    let artistDisplayName: String?
    let performanceDate: String?
    let artistImageUrl: String?
}

extension ArtistResponse {
    var toDomain: Artist? {
        guard let artistId else { return nil }
        let performanceDate = performanceDate?.toDate(dateFormat: .performanceDate)
        
        return .init(
            id: artistId.string,
            name: artistDisplayName ?? "",
            performanceDate: performanceDate,
            imageURLString: artistImageUrl
        )
    }
}

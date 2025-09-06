//
//  ArtistResponse.swift
//  Data
//
//  Created by 이정원 on 7/17/25.
//  Copyright © 2025 Darayo. All rights reserved.
//

import Foundation
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
        
        return .init(
            id: artistId.string,
            name: artistDisplayName ?? "",
            performanceDate: performanceDate?.toDate,
            imageURLString: artistImageUrl
        )
    }
}

private extension String {
    var toDate: Date? {
        let distantPast = Date.distantPast.toString(dateFormat: .performanceDate)
        let hasPerformanceDate = self != distantPast
        guard hasPerformanceDate else { return nil }
        return toDate(dateFormat: .performanceDate)
    }
}

//
//  LikedFestival.swift
//  Data
//
//  Created by 이정원 on 7/22/25.
//  Copyright © 2025 Darayo. All rights reserved.
//

import Foundation
import SwiftData
import Domain

@Model
public final class LikedFestival: @unchecked Sendable {
    @Attribute(.unique) public var id: Int
    var creationDate: Date

    init(id: Int, creationDate: Date) {
        self.id = id
        self.creationDate = creationDate
    }
}

extension LikedFestival {
    var toDomain: Domain.LikedFestival {
        return .init(id: id, creationDate: creationDate)
    }
}

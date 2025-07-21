//
//  LikedFestival.swift
//  Domain
//
//  Created by 이정원 on 7/22/25.
//  Copyright © 2025 Darayo. All rights reserved.
//

import Foundation

public struct LikedFestival: Equatable, Hashable {
    public let id: Int
    public let creationDate: Date
    
    public init(id: Int, creationDate: Date) {
        self.id = id
        self.creationDate = creationDate
    }
}

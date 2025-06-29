//
//  Festival.swift
//  Domain
//
//  Created by 이정원 on 6/24/25.
//  Copyright © 2025 Darayo. All rights reserved.
//

import Foundation

public struct Festival: Hashable {
    public let title: String
    public let dateString: String
    public let place: String
    
    public init(
        title: String,
        dateString: String,
        place: String
    ) {
        self.title = title
        self.dateString = dateString
        self.place = place
    }
}

//
//  Artist.swift
//  Domain
//
//  Created by 이정원 on 7/1/25.
//  Copyright © 2025 Darayo. All rights reserved.
//

import Foundation

public struct Artist: Equatable, Hashable {
    public let id: String
    public let name: String
    public let performanceDate: Date?
    public let imageURLString: String
    
    public init(
        id: String,
        name: String,
        performanceDate: Date?,
        imageURLString: String = ""
    ) {
        self.id = id
        self.name = name
        self.performanceDate = performanceDate
        self.imageURLString = imageURLString
    }
}

//
//  Artist.swift
//  Domain
//
//  Created by 이정원 on 7/1/25.
//  Copyright © 2025 Darayo. All rights reserved.
//

import Foundation

public struct Artist: Hashable {
    public let id: String
    public let name: String
    public let imageURLString: String
    
    public init(
        id: String = UUID().uuidString,
        name: String,
        imageURLString: String
    ) {
        self.id = id
        self.name = name
        self.imageURLString = imageURLString
    }
}

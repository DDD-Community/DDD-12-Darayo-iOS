//
//  Artist.swift
//  Domain
//
//  Created by 이정원 on 7/1/25.
//  Copyright © 2025 Darayo. All rights reserved.
//

public struct Artist {
    public let name: String
    public let imageURLString: String
    
    public init(
        name: String,
        imageURLString: String
    ) {
        self.name = name
        self.imageURLString = imageURLString
    }
}

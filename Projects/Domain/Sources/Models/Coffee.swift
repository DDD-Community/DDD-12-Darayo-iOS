//
//  Coffee.swift
//  Domain
//
//  Created by 이정원 on 6/9/25.
//  Copyright © 2025 Darayo. All rights reserved.
//

public struct Coffee {
    public let id: Int
    public let title: String
    public let description: String
    public let imageURLString: String
    
    public init(
        id: Int,
        title: String,
        description: String,
        imageURLString: String
    ) {
        self.id = id
        self.title = title
        self.description = description
        self.imageURLString = imageURLString
    }
}

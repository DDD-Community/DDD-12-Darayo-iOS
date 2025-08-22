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
    let imageURLString: String?
    
    public init(
        id: String,
        name: String,
        performanceDate: Date?,
        imageURLString: String? = nil
    ) {
        self.id = id
        self.name = name
        self.performanceDate = performanceDate
        self.imageURLString = imageURLString
    }
    
    public func imageURL(_ size: Int) -> URL? {
        guard let imageURLString else { return nil }
        let urlString = imageURLString
            .replacingOccurrences(of: "{w}x{h}", with: "\(size)x\(size)")
        return URL(string: urlString)
    }
}

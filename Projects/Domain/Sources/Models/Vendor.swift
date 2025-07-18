//
//  Vendor.swift
//  Domain
//
//  Created by 이정원 on 6/30/25.
//  Copyright © 2025 Darayo. All rights reserved.
//

public struct Vendor {
    public let name: String
    public let urlString: String
    
    public init(
        name: String,
        urlString: String
    ) {
        self.name = name
        self.urlString = urlString
    }
}

//
//  CoffeeResponse.swift
//  Data
//
//  Created by 이정원 on 6/9/25.
//  Copyright © 2025 Darayo. All rights reserved.
//

import Domain

struct CoffeeResponse: Decodable {
    let id: Int?
    let title: String?
    let description: String?
    let image: String?
}

extension CoffeeResponse {
    var toDomain: Coffee? {
        guard let id else { return nil }
        return .init(
            id: id,
            title: title ?? "",
            description: description ?? "",
            imageURLString: image ?? ""
        )
    }
}

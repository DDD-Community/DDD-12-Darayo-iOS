//
//  FestivalEndpoint.swift
//  Data
//
//  Created by 이정원 on 7/15/25.
//  Copyright © 2025 Darayo. All rights reserved.
//

enum FestivalEndpoint: Endpoint {
    case fetchFestivals
    
    var path: String {
        switch self {
        case .fetchFestivals: "v1/festival"
        }
    }
    
    var method: HTTPMethod {
        switch self {
        case .fetchFestivals: .get
        }
    }
    
    var queryParameters: Encodable? { nil }
    
    var body: Encodable? { nil }
}

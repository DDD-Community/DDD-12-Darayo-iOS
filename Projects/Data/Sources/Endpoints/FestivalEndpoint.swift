//
//  FestivalEndpoint.swift
//  Data
//
//  Created by 이정원 on 7/17/25.
//  Copyright © 2025 Darayo. All rights reserved.
//

enum FestivalEndpoint {
    private enum Path {
        static let fetchFestivals = "v1/festival"
        static func fetchFestival(_ id: Int) -> String {
            return "v1/festival/\(id)"
        }
    }
    
    static var fetchFestivals: APIEndpoint<[FestivalResponse]> {
        return .init(path: Path.fetchFestivals, method: .get)
    }
    
    static func fetchFestival(_ id: Int) -> APIEndpoint<FestivalResponse> {
        return .init(path: Path.fetchFestival(id), method: .get)
    }
}

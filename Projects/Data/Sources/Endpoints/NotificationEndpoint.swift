//
//  NotificationEndpoint.swift
//  Data
//
//  Created by 이정원 on 7/17/25.
//  Copyright © 2025 Darayo. All rights reserved.
//

enum NotificationEndpoint {
    private enum Path {
        static let registerPushToken = "v1/user/alarm"
        static let fetchSubscribedFestivals = "v1/festival/alarmed"
    }
    
    static func registerPushToken(token: String?) -> APIEndpoint<String> {
        return .init(
            path: Path.registerPushToken,
            method: .put,
            body: PushTokenRequest(token: token)
        )
    }
    
    static var fetchSubscribedFestivals: APIEndpoint<[FestivalResponse]> {
        return .init(
            path: Path.fetchSubscribedFestivals,
            method: .get
        )
    }
}

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
        static let notification = "v1/users/push-permission"
        
        static func subscription(festivalID: String) -> String {
            "v1/festival/\(festivalID)/push"
        }
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
    
    static func fetchSubsrciptionInfo(festivalID: String) -> APIEndpoint<Bool> {
        return .init(
            path: Path.subscription(festivalID: festivalID),
            method: .get
        )
    }
    
    static func subscribe(festivalID: String) -> APIEndpoint<String> {
        return .init(
            path: Path.subscription(festivalID: festivalID),
            method: .post
        )
    }
    
    static func unsubscribe(festivalID: String) -> APIEndpoint<String> {
        return .init(
            path: Path.subscription(festivalID: festivalID),
            method: .delete
        )
    }
    
    static var fetchNotificationState: APIEndpoint<Bool> {
        return .init(
            path: Path.notification,
            method: .get
        )
    }
    
    static func updtateNotificationState(isEnabled: Bool) -> APIEndpoint<String> {
        let body = NotificationRequest(permissionEnabled: isEnabled)
        
        return .init(
            path: Path.notification,
            method: .post,
            body: body
        )
    }
}

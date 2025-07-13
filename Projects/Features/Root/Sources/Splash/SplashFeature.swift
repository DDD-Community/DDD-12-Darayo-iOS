//
//  SplashFeature.swift
//  Root
//
//  Created by 이정원 on 6/21/25.
//  Copyright © 2025 Darayo. All rights reserved.
//

import UIKit
import ComposableArchitecture
import Photos
import UserNotifications

@Reducer
public struct SplashFeature {
    public struct State {
        
    }
    
    public enum Action {
        case onAppear
        case splashDone(Bool)
    }
    
    public init() {}
    public var body: some ReducerOf<Self> {
        Reduce { state, action in
            switch action {
            case .onAppear:
                return .run { send in
                    await send(checkAuthorizationStatus())
                }
            case .splashDone: return .none
            }
        }
    }
}

private extension SplashFeature {
    func checkAuthorizationStatus() async -> Action {
        async let waiting: Void = Task.sleep(for: .seconds(1.5))
        async let shouldRequestAuthorization = isAutorizationNotDetermined
        
        try? await waiting
        return await .splashDone(shouldRequestAuthorization)
    }
    
    var isAutorizationNotDetermined: Bool {
        get async {
            await isNotificationAuthroizationNotDetermined || isPhotoAuthroizationNotDetermined
        }
    }
    
    var isNotificationAuthroizationNotDetermined: Bool {
        get async {
            let center =  UNUserNotificationCenter.current()
            let status = await center.notificationSettings().authorizationStatus
            
            if status != .notDetermined {
                DispatchQueue.main.async {
                    UIApplication.shared.registerForRemoteNotifications()
                }
            }
            return status == .notDetermined
        }
    }
    
    var isPhotoAuthroizationNotDetermined: Bool {
        PHPhotoLibrary.authorizationStatus(for: .addOnly) == .notDetermined
    }
}

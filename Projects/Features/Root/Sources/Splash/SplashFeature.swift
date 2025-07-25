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
import Domain

@Reducer
public struct SplashFeature {
    @Dependency(\.authUseCase) private var authUseCase
    @Dependency(\.notificationUseCase) private var notificationUseCase
    
    public struct State {
        
    }
    
    public enum Action {
        case onAppear
        case allTasksDone(Bool)
        case showAlert
    }
    
    public init() {}
    public var body: some ReducerOf<Self> {
        Reduce { state, action in
            switch action {
            case .onAppear:
                return .run { send in
                    await send(doAllTasks())
                }
            case .allTasksDone: return .none
            case .showAlert: return .none
            }
        }
    }
}

private extension SplashFeature {
    func doAllTasks() async -> Action {
        do {
            async let waiting: Void = Task.sleep(for: .seconds(1.5))
            async let signIn: Void = signIn()
            async let shoulRequestAuthorization = isAutorizationNotDetermined
            
            try await signIn
            try? await waiting
            return await .allTasksDone(shoulRequestAuthorization)
        } catch {
            return .showAlert
        }
    }
    
    func signIn() async throws {
        if authUseCase.isSignedIn { return }
        try await authUseCase.signIn()
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
            
            if status == .denied {
                try? await notificationUseCase.updateNotification(isEnabled: false)
            }
            
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

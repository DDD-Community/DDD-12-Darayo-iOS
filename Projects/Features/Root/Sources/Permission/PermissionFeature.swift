//
//  PermissionFeature.swift
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
public struct PermissionFeature {
    @Dependency(\.notificationUseCase) private var notificationUseCase
    
    public struct State {
        
    }
    
    public enum Action {
        case onAppear
        case buttonTapped
        case allPermissionsCompleted
        case showAlert
    }
    
    public init() {}
    public var body: some ReducerOf<Self> {
        Reduce { state, action in
            switch action {
            case .onAppear: return .none
            case .buttonTapped:
                return .run { send in
                    await send(requestAllAuthorizations())
                }
            case .allPermissionsCompleted: return .none
            case .showAlert:
                // TODO: Alert 표시
                return .none
            }
        }
    }
}

private extension PermissionFeature {
    func requestAllAuthorizations() async -> Action {
        do {
            try await requestNotificationAuthorization()
            // await requestPhotoAuthorization()
            return .allPermissionsCompleted
        } catch {
            return .showAlert
        }
    }
    
    func requestNotificationAuthorization() async throws {
        let isGranted = try await UNUserNotificationCenter
            .current()
            .requestAuthorization(options: [.alert, .badge, .sound])
        
        try await notificationUseCase.updateNotification(isEnabled: isGranted)
        guard isGranted else { return }
        
        await MainActor.run {
            UIApplication.shared.registerForRemoteNotifications()
        }
    }
    
    func requestPhotoAuthorization() async {
        _ = await PHPhotoLibrary.requestAuthorization(for: .addOnly)
    }
}

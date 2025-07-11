//
//  SplashFeature.swift
//  Root
//
//  Created by 이정원 on 6/21/25.
//  Copyright © 2025 Darayo. All rights reserved.
//

import ComposableArchitecture
import Photos

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
                    try? await Task.sleep(for: .seconds(1.5))
                    let status = PHPhotoLibrary.authorizationStatus(for: .addOnly)
                    let shouldRequestAuthorization = status == .notDetermined
                    await send(.splashDone(shouldRequestAuthorization))
                }
            case .splashDone: return .none
            }
        }
    }
}

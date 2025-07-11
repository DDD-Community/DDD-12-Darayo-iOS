//
//  PermissionFeature.swift
//  Root
//
//  Created by 이정원 on 6/21/25.
//  Copyright © 2025 Darayo. All rights reserved.
//

import ComposableArchitecture
import Photos

@Reducer
public struct PermissionFeature {
    public struct State {
        
    }
    
    public enum Action {
        case onAppear
        case authorizationStatusFetched
    }
    
    public init() {}
    public var body: some ReducerOf<Self> {
        Reduce { state, action in
            switch action {
            case .onAppear:
                return .run { send in
                    let status = await PHPhotoLibrary.requestAuthorization(for: .addOnly)
                    print(status.rawValue)
                    await send(.authorizationStatusFetched)
                }
            case .authorizationStatusFetched: return .none
            }
        }
    }
}

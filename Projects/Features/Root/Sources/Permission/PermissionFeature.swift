//
//  PermissionFeature.swift
//  Root
//
//  Created by 이정원 on 6/21/25.
//  Copyright © 2025 Darayo. All rights reserved.
//

import ComposableArchitecture

@Reducer
public struct PermissionFeature {
    public struct State {
        
    }
    
    public enum Action {
        case onAppear
        case timeElapsed
    }
    
    public init() {}
    public var body: some ReducerOf<Self> {
        Reduce { state, action in
            switch action {
            case .onAppear:
                // MARK: 임시로 1.5초 지연, 추후 권한 허용 로직 구현 필요
                return .run { send in
                    try? await Task.sleep(for: .seconds(1.5))
                    await send(.timeElapsed)
                }
            case .timeElapsed: return .none
            }
        }
    }
}

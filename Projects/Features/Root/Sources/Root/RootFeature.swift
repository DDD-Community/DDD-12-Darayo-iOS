//
//  RootFeature.swift
//  Root
//
//  Created by 이정원 on 6/8/25.
//  Copyright © 2025 Darayo. All rights reserved.
//

import ComposableArchitecture
import Domain

@Reducer
public struct RootFeature {
    public struct State {
        var path: Path.State = .splash(.init())
        public init() {}
    }
    
    public enum Action {
        case path(Path.Action)
    }
    
    public init() {}
    public var body: some ReducerOf<Self> {
        Scope(state: \.path, action: \.path) {
            Path()
        }
        
        Reduce { state, action in
            switch action {
            case .path(.splash(.splashDone(let shouldRequestAuthorization))):
                state.path = switch shouldRequestAuthorization {
                case true: .permission(.init())
                case false: .main(.init())
                }
                return .none
            case .path(.permission(.authorizationStatusFetched)):
                state.path = .main(.init())
                return .none
            default: return .none
            }
        }
    }
}

extension RootFeature {
    @Reducer
    public struct Path {
        @ObservableState
        public enum State {
            case splash(SplashFeature.State)
            case permission(PermissionFeature.State)
            case main(MainFeature.State)
        }
        
        public enum Action {
            case splash(SplashFeature.Action)
            case permission(PermissionFeature.Action)
            case main(MainFeature.Action)
        }
        
        public var body: some ReducerOf<Self> {
            Scope(state: \.splash, action: \.splash) {
                SplashFeature()
            }
            
            Scope(state: \.permission, action: \.permission) {
                PermissionFeature()
            }
            
            Scope(state: \.main, action: \.main) {
                MainFeature()
            }
        }
    }
}

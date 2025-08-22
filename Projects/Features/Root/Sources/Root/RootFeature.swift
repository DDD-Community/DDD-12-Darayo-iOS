//
//  RootFeature.swift
//  Root
//
//  Created by 이정원 on 6/8/25.
//  Copyright © 2025 Darayo. All rights reserved.
//

import UIKit
import ComposableArchitecture
import Domain
import Base

@Reducer
public struct RootFeature {
    @ObservableState
    public struct State {
        var path: Path.State = .splash(.init())
        @Presents var alert: CustomAlert<AlertCase>.State?
        
        public init() {}
    }
    
    public enum Action {
        case path(Path.Action)
        case alert(PresentationAction<CustomAlert<AlertCase>.Action>)
        case showAlert(AlertCase)
    }
    
    public init() {}
    public var body: some ReducerOf<Self> {
        Scope(state: \.path, action: \.path) {
            Path()
        }
        
        Reduce { state, action in
            switch action {
            case .path(.splash(.allTasksDone(let shouldRequestAuthorization))):
                state.path = switch shouldRequestAuthorization {
                case true: .permission(.init())
                case false: .main(.init())
                }
                return .none
            case .path(.permission(.allPermissionsCompleted)):
                state.path = .main(.init())
                return .none
            case .path(.main(.showAlert(let alertCase))):
                return .send(.showAlert(.main(alertCase)))
            case .showAlert(let alertCase):
                state.alert = .init(alertCase)
                return .none
            default: return .none
            }
        }
        .ifLet(\.$alert, action: \.alert) {
            CustomAlert()
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

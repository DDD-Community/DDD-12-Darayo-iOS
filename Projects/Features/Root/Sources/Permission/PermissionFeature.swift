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
        public init() {}
    }
    
    public enum Action {
        
    }
    
    public init() {}
    public var body: some ReducerOf<Self> {
        Reduce { state, action in
            return .none
        }
    }
}

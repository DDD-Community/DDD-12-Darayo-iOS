//
//  FestivalFeature.swift
//  Home
//
//  Created by 이정원 on 6/29/25.
//  Copyright © 2025 Darayo. All rights reserved.
//

import ComposableArchitecture
import Domain

@Reducer
public struct FestivalFeature {
    public struct State {
        let festival: Festival
        
        public init(festival: Festival) {
            self.festival = festival
        }
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

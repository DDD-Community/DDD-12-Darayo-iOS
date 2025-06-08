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
    @Dependency(\.sampleUseCase) private var sampleUseCase
    
    public struct State {
        public init() {}
    }
    
    public enum Action {
        case onAppear
    }
    
    public init() {}
    public var body: some ReducerOf<Self> {
        Reduce { state, action in
            switch action {
            case .onAppear:
                sampleUseCase.helloWorld()
                return .none
            }
        }
    }
}

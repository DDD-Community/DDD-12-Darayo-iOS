//
//  InquiryFeature.swift
//  MyPage
//
//  Created by 이정원 on 7/6/25.
//  Copyright © 2025 Darayo. All rights reserved.
//

import ComposableArchitecture

@Reducer
public struct InquiryFeature {
    @ObservableState
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

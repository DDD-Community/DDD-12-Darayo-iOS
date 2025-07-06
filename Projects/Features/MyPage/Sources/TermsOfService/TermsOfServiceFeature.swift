//
//  TermsOfServiceFeature.swift
//  MyPage
//
//  Created by 이정원 on 7/6/25.
//  Copyright © 2025 Darayo. All rights reserved.
//

import ComposableArchitecture
import Util

@Reducer
public struct TermsOfServiceFeature {
    @Dependency(\.dismiss) private var dismiss
    
    @ObservableState
    public struct State {
        let text = Constant.Text.termsOfService
        public init() {}
    }
    
    public enum Action {
        case backButtonTapped
    }
    
    public init() {}
    public var body: some ReducerOf<Self> {
        Reduce { state, action in
            switch action {
            case .backButtonTapped:
                return .run { _ in await dismiss() }
            }
        }
    }
}

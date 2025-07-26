//
//  CustomAlertFeature.swift
//  Base
//
//  Created by 이정원 on 7/25/25.
//  Copyright © 2025 Darayo. All rights reserved.
//

import ComposableArchitecture

@Reducer
public struct CustomAlert {
    @ObservableState
    public struct State {        
        let title: String
        let message: String?
        let buttonTitle: String
        
        public init(
            title: String,
            message: String? = nil,
            buttonTitle: String
        ) {
            self.title = title
            self.message = message
            self.buttonTitle = buttonTitle
        }
    }
    
    public enum Action {
        case buttonTapped
        case closeButtonTapped
    }
    
    public init() {}
    public var body: some ReducerOf<Self> {
        Reduce { state, action in
            return .none
        }
    }
}

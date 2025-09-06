//
//  CustomAlert.swift
//  Base
//
//  Created by 이정원 on 7/25/25.
//  Copyright © 2025 Darayo. All rights reserved.
//

import ComposableArchitecture

@Reducer
public struct CustomAlert<AlertCase: AlertPresentable> {
    @ObservableState
    public struct State: Equatable {
        let alertCase: AlertCase
        let canDismiss: Bool
        
        public init(_ alertCase: AlertCase, _ canDismiss: Bool = true) {
            self.alertCase = alertCase
            self.canDismiss = canDismiss
        }
    }
    
    public enum Action {
        case buttonTapped(AlertCase)
    }
    
    public init() {}
    public var body: some ReducerOf<Self> {
        Reduce { state, action in
            return .none
        }
    }
}

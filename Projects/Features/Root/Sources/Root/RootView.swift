//
//  RootView.swift
//  Root
//
//  Created by 이정원 on 6/8/25.
//  Copyright © 2025 Darayo. All rights reserved.
//

import SwiftUI
import ComposableArchitecture
import Domain
import Base

public struct RootView: View {
    @Bindable private var store: StoreOf<RootFeature>
    
    public init(store: StoreOf<RootFeature>) {
        self.store = store
    }
    
    public var body: some View {
        let store = store.scope(state: \.path, action: \.path)
        Group {
            switch store.state {
            case .splash:
                if let store = store.scope(state: \.splash, action: \.splash) {
                    SplashView(store: store)
                }
            case .permission:
                if let store = store.scope(state: \.permission, action: \.permission) {
                    PermissionView(store: store)
                }
            case .main:
                if let store = store.scope(state: \.main, action: \.main) {
                    MainView(store: store)
                }
            }
        }
        .customAlert($store.scope(state: \.alert, action: \.alert))
    }
}

extension RootFeature.AlertCase: AlertPresentable {
    public var alertInfo: AlertInfo {
        switch self {
        case .main(let alertCase): alertCase.alertInfo
        }
    }
}

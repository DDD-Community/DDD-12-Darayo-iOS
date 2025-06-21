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

public struct RootView: View {
    private let store: StoreOf<RootFeature>
    
    public init(store: StoreOf<RootFeature>) {
        self.store = store
    }
    
    public var body: some View {
        let store = store.scope(state: \.path, action: \.path)
        switch store.state {
        case .splash:
            if let store = store.scope(state: \.splash, action: \.splash) {
                SplashView(store: store)
            }
        case .permission:
            if let store = store.scope(state: \.permission, action: \.permission) {
                PermissionView(store: store)
            }
        }
    }
}

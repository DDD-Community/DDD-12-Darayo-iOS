//
//  SplashView.swift
//  Root
//
//  Created by 이정원 on 6/21/25.
//  Copyright © 2025 Darayo. All rights reserved.
//

import SwiftUI
import ComposableArchitecture
import DesignSystem

public struct SplashView: View {
    private let store: StoreOf<SplashFeature>
    
    public init(store: StoreOf<SplashFeature>) {
        self.store = store
    }
    
    public var body: some View {
        Color.point1
            .ignoresSafeArea()
            .onAppear { store.send(.onAppear) }
    }
}

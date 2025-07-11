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
        ZStack {
            background
            VStack(spacing: 0) {
                characterImage
                logo
                slogan
            }
        }
        .onAppear { store.send(.onAppear) }
    }
}

private extension SplashView {
    var background: some View {
        Color.black
            .ignoresSafeArea()
            .overlay(alignment: .bottom) { gradient }
    }
    
    var gradient: some View {
        RadialGradient(
            gradient: Gradient(stops: [
                .init(color: Color.gradientSplash1.opacity(0.5), location: 0.0),
                .init(color: Color.gradientSplash2.opacity(0.0), location: 1.0)
            ]),
            center: .bottom,
            startRadius: 0,
            endRadius: 200
        )
        .ignoresSafeArea()
    }
    
    var characterImage: some View {
        Image.characterSplash
    }
    
    var logo: some View {
        Image.logoSplash
            .padding(.top, 20)
    }
    
    var slogan: some View {
        Text("슬로건슬로건슬로건")
            .pretendard(style: .title4)
            .foregroundStyle(Color.grey3)
            .padding(.top, 8)
    }
}

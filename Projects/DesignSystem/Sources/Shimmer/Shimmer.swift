//
//  Shimmer.swift
//  DesignSystem
//
//  Created by 이정원 on 7/15/25.
//  Copyright © 2025 Darayo. All rights reserved.
//

import SwiftUI

public struct ShimmerView: View {
    private let gradientColors: [Color] = [
        Color.grey5.opacity(0.2),
        Color.grey1.opacity(0.2),
        Color.grey5.opacity(0.2)
    ]
    
    @State private var startPoint: UnitPoint = .init(x: -1.8, y: -1.2)
    @State private var endPoint: UnitPoint = .init(x: 0, y: -0.2)
    
    public init() {}
    public var body: some View {
        LinearGradient(
            colors: gradientColors,
            startPoint: startPoint,
            endPoint: endPoint
        )
        .onAppear {
            withAnimation(
                .easeInOut (duration: 1)
                .repeatForever (autoreverses: false)
            ) {
                startPoint = .init(x: 1, y: 1)
                endPoint = .init(x: 2.2, y: 2.2)
            }
        }
    }
}

struct ShimmerViewModifier: ViewModifier {
    private let isLoading: Bool
    private let size: CGSize

    init(isLoading: Bool, size: CGSize) {
        self.isLoading = isLoading
        self.size = size
    }
    
    func body(content: Content) -> some View {
        ZStack {
            ShimmerView()
                .frame(width: size.width, height: size.height)
                .renderedIf(isLoading)
            
            content
                .renderedIf(!isLoading)
        }
    }
}

public extension View {
    func shimmer(isLoading: Bool, size: CGSize) -> some View {
        modifier(ShimmerViewModifier(isLoading: isLoading, size: size))
    }
}

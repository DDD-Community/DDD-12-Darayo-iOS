//
//  Gradient.swift
//  DesignSystem
//
//  Created by 이정원 on 7/6/25.
//  Copyright © 2025 Darayo. All rights reserved.
//

import SwiftUI

public extension View {
    func gradient(height: CGFloat) -> some View {
        overlay(alignment: .bottom) {
            LinearGradient(
                stops: [
                    Gradient.Stop(color: Color.background1.opacity(0), location: 0.00),
                    Gradient.Stop(color: Color.background1, location: 1.00)
                ],
                startPoint: .top,
                endPoint: .bottom
            )
            .frame(height: height)
            .allowsHitTesting(false)
        }
        .ignoresSafeArea(edges: .bottom)
    }
}

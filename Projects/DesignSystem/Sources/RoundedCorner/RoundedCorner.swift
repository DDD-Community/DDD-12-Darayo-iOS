//
//  RoundedCorner.swift
//  DesignSystem
//
//  Created by 이정원 on 6/22/25.
//  Copyright © 2025 Darayo. All rights reserved.
//

import SwiftUI

public struct RoundedCorner: Shape {
    private let radius: CGFloat
    private let corners: UIRectCorner
    
    public init(radius: CGFloat, corners: UIRectCorner) {
        self.radius = radius
        self.corners = corners
    }

    public func path(in rect: CGRect) -> Path {
        let path = UIBezierPath(
            roundedRect: rect,
            byRoundingCorners: corners,
            cornerRadii: CGSize(width: radius, height: radius)
        )
        return Path(path.cgPath)
    }
}

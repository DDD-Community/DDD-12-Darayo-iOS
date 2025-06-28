//
//  RenderedIf.swift
//  DesignSystem
//
//  Created by 이정원 on 6/28/25.
//  Copyright © 2025 Darayo. All rights reserved.
//

import SwiftUI

public struct RenderedIf: ViewModifier {
    private let condition: Bool
    
    init(_ condition: Bool) {
        self.condition = condition
    }
    
    @ViewBuilder public func body(content: Content) -> some View {
        if condition {
            content
        }
    }
}

public extension View {
    func renderedIf(_ condition: Bool) -> some View {
        modifier(RenderedIf(condition))
    }
}

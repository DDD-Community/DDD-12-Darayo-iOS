//
//  OffsetScrollView.swift
//  DesignSystem
//
//  Created by 이정원 on 8/7/25.
//  Copyright © 2025 Darayo. All rights reserved.
//

import SwiftUI

public struct OffsetScrollView<Content>: View where Content: View {
    @Namespace private var coordinateSpaceName: Namespace.ID
    @Binding private var scrollOffset: CGFloat
    private let content: () -> Content
    
    public init(
        scrollOffset: Binding<CGFloat>,
        content: @escaping () -> Content
    ) {
        self._scrollOffset = scrollOffset
        self.content = content
    }
    
    public var body: some View {
        ScrollView {
            VStack(spacing: 0) {
                GeometryReader { proxy in
                    Color.clear
                        .preference(
                            key: ScrollOffsetPreferenceKey.self,
                            value: proxy.frame(in: .named(coordinateSpaceName)).minY
                        )
                }
                .frame(height: 0)
                
                content()
            }
        }
        .coordinateSpace(name: coordinateSpaceName)
        .onPreferenceChange(ScrollOffsetPreferenceKey.self) { value in
            scrollOffset = value * -1
        }
    }
}

struct ScrollOffsetPreferenceKey: PreferenceKey {
    static let defaultValue: CGFloat = 0
    
    static func reduce(value: inout CGFloat, nextValue: () -> CGFloat) {
        value += nextValue()
    }
}

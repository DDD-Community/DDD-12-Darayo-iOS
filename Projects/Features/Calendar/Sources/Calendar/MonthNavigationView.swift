//
//  MonthNavigationView.swift
//  DesignSystem
//
//  Created by 이다영 on 6/28/25.
//  Copyright © 2025 Darayo. All rights reserved.
//

import SwiftUI

struct MonthNavigationView: View {
    let currentMonth: Date
    let onPreviousMonth: () -> Void
    let onNextMonth: () -> Void
    
    private let dateFormatter: DateFormatter = {
        let formatter = DateFormatter()
        formatter.locale = Locale(identifier: "ko_KR")
        formatter.dateFormat = "yyyy.MM"
        return formatter
    }()
    
    var body: some View {
        HStack(spacing: 12) {
            Button(action: onPreviousMonth) {
                Image.iconChevronLeft
                    .resizable()
                    .frame(width: 24, height: 24)
                    .foregroundColor(.white)
            }
            .buttonStyle(.plain)
            .pressEffect()
            
            Text(dateFormatter.string(from: currentMonth))
                .pretendard(style: .title3)
                .foregroundColor(.white)
            
            Button(action: onNextMonth) {
                Image.iconChevronRight
                    .resizable()
                    .frame(width: 24, height: 24)
                    .foregroundColor(.white)
            }
            .buttonStyle(.plain)
            .pressEffect()
        }
        .frame(maxWidth: .infinity, alignment: .center)
    }
}

// MARK: - 눌림 효과
private extension View {
    func pressEffect(scale: CGFloat = 0.92, opacity: Double = 0.7) -> some View {
        modifier(PressEffect(scale: scale, opacity: opacity))
    }
}

private struct PressEffect: ViewModifier {
    @State private var isPressed = false
    let scale: CGFloat
    let opacity: Double
    
    func body(content: Content) -> some View {
        content
            .scaleEffect(isPressed ? scale : 1)
            .opacity(isPressed ? opacity : 1)
            .animation(.easeOut(duration: 0.12), value: isPressed)
            .gesture(
                DragGesture(minimumDistance: 0)
                    .onChanged { _ in if !isPressed { isPressed = true } }
                    .onEnded { _ in isPressed = false }
            )
    }
}

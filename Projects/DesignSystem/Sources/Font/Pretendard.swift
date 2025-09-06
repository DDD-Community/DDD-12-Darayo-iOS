//
//  Pretendard.swift
//  DesignSystem
//
//  Created by 이정원 on 6/11/25.
//  Copyright © 2025 Darayo. All rights reserved.
//

import SwiftUI

public typealias Pretendard = DesignSystemFontFamily.Pretendard

struct PretendardModifier: ViewModifier {
    private let size: CGFloat
    private let weight: Pretendard.Weight
    private let multiplier: CGFloat
    
    init(
        size: CGFloat,
        weight: Pretendard.Weight,
        multiplier: CGFloat = 1.3
    ) {
        self.size = size
        self.weight = weight
        self.multiplier = multiplier
    }
    
    func body(content: Content) -> some View {
        content
            .font(weight.font.swiftUIFont(size: size))
            .lineSpacing(lineSpacing)
            .padding(.vertical, lineSpacing / 2)
            .kerning(-0.5)
    }
    
    private var lineSpacing: CGFloat {
        let lineHeight = weight.font.font(size: size).lineHeight
        return size * multiplier - lineHeight
    }
}

public extension View {
    func pretendard(style: Pretendard.TextStyle) -> some View {
        modifier(
            PretendardModifier(
                size: style.size,
                weight: style.weight
            )
        )
    }
    
    func pretendard(size: CGFloat, weight: Pretendard.Weight) -> some View {
        modifier(PretendardModifier(size: size, weight: weight))
    }
}

extension Pretendard {
    public enum Weight {
        case thin
        case extraLight
        case light
        case regular
        case medium
        case semiBold
        case bold
        case extraBold
        case black
        
        var font: DesignSystemFontConvertible {
            switch self {
            case .thin: Pretendard.thin
            case .extraLight: Pretendard.extraLight
            case .light: Pretendard.light
            case .regular: Pretendard.regular
            case .medium: Pretendard.medium
            case .semiBold: Pretendard.semiBold
            case .bold: Pretendard.bold
            case .extraBold: Pretendard.extraBold
            case .black: Pretendard.black
            }
        }
    }
    
    public enum TextStyle {
        case title1
        case title2
        case title3
        case title4
        case body0
        case body1
        case body2
        case body3
        case body4
        case caption1
        case caption2
        
        var size: CGFloat {
            switch self {
            case .title1: 22
            case .title2: 18
            case .title3: 16
            case .title4: 16
            case .body0: 15
            case .body1: 16
            case .body2: 14
            case .body3: 14
            case .body4: 14
            case .caption1: 12
            case .caption2: 12
            }
        }
        
        var weight: Weight {
            switch self {
            case .title1: .bold
            case .title2: .semiBold
            case .title3: .semiBold
            case .title4: .medium
            case .body0: .regular
            case .body1: .regular
            case .body2: .semiBold
            case .body3: .medium
            case .body4: .regular
            case .caption1: .medium
            case .caption2: .regular
            }
        }
    }
}

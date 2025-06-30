//
//  FestibeeButtonStyle.swift
//  DesignSystem
//
//  Created by 이정원 on 6/30/25.
//  Copyright © 2025 Darayo. All rights reserved.
//

import SwiftUI

public struct FestibeeButtonStyle: ButtonStyle {
    @Environment(\.isEnabled) private var isEnabled
    
    public func makeBody(configuration: Configuration) -> some View {
        configuration.label
            .pretendard(style: .title4)
            .frame(maxWidth: .infinity)
            .frame(height: 50)
            .foregroundStyle(isEnabled ? Color.black : Color.white)
            .background(isEnabled ? Color.point1 : Color.grey5)
            .clipShape(RoundedRectangle(cornerRadius: 10))
            .opacity(configuration.isPressed ? 0.5 : 1.0)
    }
}

public extension ButtonStyle where Self == FestibeeButtonStyle {
    static var festibee: FestibeeButtonStyle {
        FestibeeButtonStyle()
    }
}

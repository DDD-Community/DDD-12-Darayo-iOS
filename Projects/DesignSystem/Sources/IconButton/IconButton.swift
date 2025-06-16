//
//  IconButton.swift
//  DesignSystem
//
//  Created by 이정원 on 6/14/25.
//  Copyright © 2025 Darayo. All rights reserved.
//

import SwiftUI

public struct IconButton: View {
    private let icon: Image
    private let action: () -> Void
    
    public init(
        icon: Image,
        action: @escaping () -> Void
    ) {
        self.icon = icon
        self.action = action
    }
    
    public var body: some View {
        Button(action: action) {
            ZStack {
                Color.point1
                    .frame(width: 56, height: 56)
                    .clipShape(Circle())
                
                icon
                    .resizable()
                    .renderingMode(.template)
                    .foregroundStyle(.black)
                    .frame(width: 24, height: 24)
            }
        }
    }
}

//
//  Navigation.swift
//  DesignSystem
//
//  Created by 이정원 on 7/6/25.
//  Copyright © 2025 Darayo. All rights reserved.
//

import SwiftUI

public extension View {
    func navigation(title: String, action: @escaping () -> Void) -> some View {
        VStack(spacing: 0) {
            ZStack(alignment: .leading) {
                Text(title)
                    .pretendard(style: .title2)
                    .frame(maxWidth: .infinity)
                
                Button(action: action) {
                    Image.iconArrowLeft
                        .resizable()
                        .frame(width: 24, height: 24)
                        .padding(16)
                }
            }
            self
        }
        .navigationBarBackButtonHidden()
    }
}

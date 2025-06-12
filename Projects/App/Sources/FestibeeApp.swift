//
//  FestibeeApp.swift
//  Darayo
//
//  Created by 이정원 on 6/1/25.
//  Copyright © 2025 Darayo. All rights reserved.
//

import SwiftUI
import Root
import DesignSystem

@main
struct FestibeeApp: App {
    init() {
        DesignSystemFontFamily.registerAllCustomFonts()
    }
    
    var body: some Scene {
        WindowGroup {
            VStack(spacing: 8) {
                Text("달아요 S2 화이팅~")
                    .pretendard(style: .title1)
                    .foregroundStyle(Color.point1)
                
                Text("달아요 S2 화이팅~")
                    .pretendard(size: 24, weight: .extraLight)
                    .foregroundStyle(Color.point2)
            }
        }
    }
}

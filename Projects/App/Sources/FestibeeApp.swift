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
            VStack(alignment: .leading) {
                Text("달아요 S2 화이팅~")
                    .pretendard(style: .body1)
                
                Text("달아요 S2 화이팅~")
                    .pretendard(size: 20, weight: .thin)
                
                HStack(alignment: .top) {
                    VStack(spacing: 0) {
                        Text("달아요 S2 화이팅~")
                            .pretendard(style: .body4)
                        Text("달아요 S2 화이팅~")
                            .pretendard(style: .body4)
                        Text("달아요 S2 화이팅~")
                            .pretendard(style: .body4)
                    }
                    .background(Color.mint)
                    
                    Text("달아요 S2 화이팅~\n달아요 S2 화이팅~\n달아요 S2 화이팅~")
                        .pretendard(style: .body4)
                        .background(Color.mint)
                }
            }
        }
    }
}

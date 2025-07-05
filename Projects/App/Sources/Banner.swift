//
//  Banner.swift
//  App
//
//  Created by 이정원 on 6/28/25.
//  Copyright © 2025 Darayo. All rights reserved.
//

import SwiftUI
import DesignSystem
import Util

struct Banner: View {
    private let environment = Environment.current
    
    var body: some View {
        VStack {
            Spacer()
            Text("\(environment.name) APP")
                .pretendard(size: 12, weight: .semiBold)
                .foregroundStyle(Color.white)
                .padding(.bottom, 16)
        }
        .ignoresSafeArea(.container, edges: .bottom)
        .renderedIf(environment != .prod)
    }
}

//
//  TimeHeaderView.swift
//  DesignSystem
//
//  Created by 이정원 on 6/17/25.
//  Copyright © 2025 Darayo. All rights reserved.
//

import SwiftUI

struct TimeHeaderView: View {
    private let start: Int
    private let end: Int
    
    init(start: Int, end: Int) {
        self.start = start
        self.end = end
    }
    
    var body: some View {
        VStack(spacing: 0) {
            ForEach(start..<end, id: \.self) { hour in
                VStack(spacing: 2) {
                    Color.grey6
                        .frame(width: 20, height: 1)
                    
                    Text("\(String(format: "%02d", hour)):00")
                        .pretendard(style: .caption2)
                        .foregroundStyle(Color.white)
                    
                    Spacer()
                }
                .frame(width: 50, height: 96)
            }
        }
        .padding(.top, 1)
    }
}

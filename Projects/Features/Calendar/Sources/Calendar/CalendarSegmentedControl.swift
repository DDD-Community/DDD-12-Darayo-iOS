//
//  CalendarSegmentedControl.swift
//  DesignSystem
//
//  Created by 이다영 on 8/13/25.
//  Copyright © 2025 Darayo. All rights reserved.
//

import SwiftUI

public struct CalendarSegmentedControl: View {
    @Binding var selectedMode: Int
    private let modes = ["행사일", "예매일"]
    
    public init(selectedMode: Binding<Int>) {
        self._selectedMode = selectedMode
    }
    
    public var body: some View {
        GeometryReader { geometry in
            let totalWidth = geometry.size.width
            let segmentWidth = totalWidth / CGFloat(modes.count)
            
            ZStack(alignment: .leading) {
                Capsule()
                    .fill(Color.black)
                
                Capsule()
                    .fill(Color.grey6)
                    .frame(width: segmentWidth)
                    .offset(x: CGFloat(selectedMode) * segmentWidth)
                    .animation(.easeInOut(duration: 0.2), value: selectedMode)
                
                // 텍스트
                HStack(spacing: 0) {
                    ForEach(0..<modes.count, id: \.self) { index in
                        Text(modes[index])
                            .pretendard(style: selectedMode == index ? .body2 : .body3)
                            .foregroundColor(selectedMode == index ? .white : .grey3)
                            .frame(maxWidth: .infinity)
                            .contentShape(Rectangle())
                            .onTapGesture {
                                selectedMode = index
                            }
                    }
                }
            }
        }
        .frame(height: 34)
        .padding(.horizontal, 16)
        .padding(.top, 8)
        .padding(.bottom, 16)
    }
}

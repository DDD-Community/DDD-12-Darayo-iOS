//
//  CalendarSegmentedControl.swift
//  DesignSystem
//
//  Created by 이다영 on 8/13/25.
//  Copyright © 2025 Darayo. All rights reserved.
//

import SwiftUI

public struct CalendarSegmentedControl: View {
    @Binding var selectedMode: CalendarMode

    public init(selectedMode: Binding<CalendarMode>) {
        self._selectedMode = selectedMode
    }

    public var body: some View {
        GeometryReader { geometry in
            let totalWidth = geometry.size.width
            let count = CGFloat(CalendarMode.allCases.count)
            let segmentWidth = totalWidth / count

            ZStack(alignment: .leading) {
                // 배경
                Capsule().fill(Color.black)

                // 선택 하이라이트
                Capsule()
                    .fill(Color.grey6)
                    .frame(width: segmentWidth)
                    .offset(x: CGFloat(selectedMode.rawValue) * segmentWidth)
                    .animation(.easeInOut(duration: 0.2), value: selectedMode)

                // 라벨
                HStack(spacing: 0) {
                    ForEach(CalendarMode.allCases, id: \.self) { mode in
                        Text(mode.title)
                            .pretendard(style: selectedMode == mode ? .body2 : .body3)
                            .foregroundColor(selectedMode == mode ? .white : .grey3)
                            .frame(maxWidth: .infinity)
                            .contentShape(Rectangle())
                            .onTapGesture { selectedMode = mode }
                    }
                }
            }
        }
        .frame(height: 34)
        .padding(.horizontal, 16)
        .padding(.top, 8)
    }
}

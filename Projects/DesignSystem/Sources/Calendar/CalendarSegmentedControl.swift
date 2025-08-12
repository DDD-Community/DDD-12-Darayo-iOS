//
//  CalendarSegmentedControl.swift
//  DesignSystem
//
//  Created by 이다영 on 8/9/25.
//  Copyright © 2025 Darayo. All rights reserved.
//

import SwiftUI

public struct CalendarSegmentedControl: View {
    public enum CalendarType: CaseIterable {
        case ticketing  // 예매일
        case event      // 행사일
        
        var title: String {
            switch self {
            case .ticketing: return "예매일"
            case .event: return "행사일"
            }
        }
    }
    
    @Binding var selectedType: CalendarType
    let onSelectionChanged: (CalendarType) -> Void
    
    public init(
        selectedType: Binding<CalendarType>,
        onSelectionChanged: @escaping (CalendarType) -> Void
    ) {
        self._selectedType = selectedType
        self.onSelectionChanged = onSelectionChanged
    }
    
    public var body: some View {
        HStack(spacing: 0) {
            ForEach(CalendarType.allCases, id: \.self) { type in
                Button(action: {
                    selectedType = type
                    onSelectionChanged(type)
                }) {
                    Text(type.title)
                        .pretendard(style: .body3)
                        .foregroundColor(selectedType == type ? .white : .grey3)
                        .frame(maxWidth: .infinity)
                        .frame(height: 40)
                        .background(
                            Group {
                                if selectedType == type {
                                    // ✅ 선택 상태일 때 배경 이미지를 적용
                                    Image.segmentedControlBackground
                                        .resizable()
                                        .scaledToFill()
                                        .clipShape(RoundedRectangle(cornerRadius: 8))
                                } else {
                                    Color.clear
                                }
                            }
                        )
                        .cornerRadius(8)
                }
            }
        }
        .padding(4)
        .background(Color.grey4)
        .cornerRadius(12)
        .animation(.easeInOut(duration: 0.2), value: selectedType)
    }
}

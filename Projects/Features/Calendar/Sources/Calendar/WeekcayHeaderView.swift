//
//  WeekcayHeaderView.swift
//  DesignSystem
//
//  Created by 이다영 on 6/28/25.
//  Copyright © 2025 Darayo. All rights reserved.
//

import SwiftUI

struct WeekdayHeaderView: View {
    private let weekdaySymbols = ["월", "화", "수", "목", "금", "토", "일"]
    
    var body: some View {
        HStack(spacing: 0) {
            ForEach(weekdaySymbols, id: \.self) { weekday in
                Text(weekday)
                    .pretendard(style: .body4)
                    .foregroundColor(.grey3)
                    .frame(maxWidth: .infinity)
            }
        }
    }
}

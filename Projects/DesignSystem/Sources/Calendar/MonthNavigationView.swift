//
//  MonthNavigationView.swift
//  DesignSystem
//
//  Created by 이다영 on 6/28/25.
//  Copyright © 2025 Darayo. All rights reserved.
//

import SwiftUI

struct MonthNavigationView: View {
    let currentMonth: Date
    let onPreviousMonth: () -> Void
    let onNextMonth: () -> Void
    
    private let dateFormatter: DateFormatter = {
        let formatter = DateFormatter()
        formatter.locale = Locale(identifier: "ko_KR")
        formatter.dateFormat = "yyyy.MM"
        return formatter
    }()
    
    var body: some View {
        HStack {
            Button(action: onPreviousMonth) {
                ZStack {
                    RoundedRectangle(cornerRadius: 6)
                        .fill(Color.background2)
                        .frame(width: 24, height: 24)
                    
                    Image(systemName: "chevron.left")
                        .resizable()
                        .frame(width: 7.43, height: 13)
                        .foregroundColor(.white)
                }
            }
            
            Spacer()
            
            Text(dateFormatter.string(from: currentMonth))
                .pretendard(style: .title3)
                .foregroundColor(.white)
            
            Spacer()
            
            Button(action: onNextMonth) {
                ZStack {
                    RoundedRectangle(cornerRadius: 6)
                        .fill(Color.background2)
                        .frame(width: 24, height: 24)
                    
                    Image(systemName: "chevron.right")
                        .resizable()
                        .frame(width: 7.43, height: 13)
                        .foregroundColor(.white)
                }
            }
        }
        .frame(maxWidth: .infinity, alignment: .center)
    }
}

//
//  EmptyInfoView.swift
//  Home
//
//  Created by 이정원 on 8/10/25.
//  Copyright © 2025 Darayo. All rights reserved.
//

import SwiftUI
import DesignSystem

struct EmptyInfoView: View {
    private let title: String
    
    init(title: String) {
        self.title = title
    }
    
    var body: some View {
        VStack(spacing: 0) {
            Text(title)
                .pretendard(style: .body3)
                .foregroundStyle(Color.point1)
                .frame(maxWidth: .infinity, alignment: .leading)
            
            VStack(spacing: 4) {
                Image.iconStarGrey
                    .renderingMode(.template)
                    .resizable()
                    .frame(width: 25, height: 25)
                    .foregroundStyle(Color.grey5)
                
                Text("아직 등록된 정보가 없어요")
                    .pretendard(style: .body4)
                    .foregroundStyle(Color.grey4)
                    .frame(maxWidth: .infinity)
            }
        }
        .padding(.vertical, 12)
        .padding(.horizontal, 16)
        .background(Color.background2)
        .clipShape(RoundedRectangle(cornerRadius: 8))
    }
}

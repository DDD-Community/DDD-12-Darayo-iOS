//
//  RegulationInfoView.swift
//  Home
//
//  Created by 이정원 on 7/1/25.
//  Copyright © 2025 Darayo. All rights reserved.
//

import SwiftUI
import DesignSystem

struct RegulationInfoView: View {
    private let regulations: [String]
    @Binding private var isExpanded: Bool
    
    init(
        regulation: String,
        isExpanded: Binding<Bool>
    ) {
        self.regulations = regulation.components(separatedBy: "\n")
        self._isExpanded = isExpanded
    }
    
    var body: some View {
        VStack(spacing: 0) {
            HStack {
                titleView
                Spacer()
                button
            }
            
            textView
                .renderedIf(isExpanded)
        }
        .background(Color.grey6)
        .clipShape(RoundedRectangle(cornerRadius: 10))
    }
}

private extension RegulationInfoView {
    var titleView: some View {
        Text("반입 규정")
            .pretendard(style: .title3)
            .foregroundStyle(Color.white)
            .padding(.leading, 16)
    }
    
    var button: some View {
        Button {
            isExpanded.toggle()
        } label: {
            Image.iconTriangle
                .renderingMode(.template)
                .resizable()
                .frame(width: 24, height: 24)
                .foregroundStyle(Color.white)
                .rotationEffect(.degrees(isExpanded ? 0 : 180))
                .padding(.horizontal, 16)
                .padding(.vertical, 12)
        }
    }
    
    var textView: some View {
        LazyVStack(spacing: 0) {
            ForEach(0..<regulations.count, id: \.self) { index in
                HStack(alignment: .top, spacing: 0) {
                    Text("  •  ")
                        .pretendard(style: .body0)
                        .foregroundStyle(Color.white)
                    
                    Text(regulations[index])
                        .pretendard(style: .body0)
                        .foregroundStyle(Color.white)
                        .frame(maxWidth: .infinity, alignment: .leading)
                }
            }
        }
        .padding(.horizontal, 16)
        .padding(.bottom, 15)
    }
}

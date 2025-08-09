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
    private let sentences: [String]
    @Binding private var isExpanded: Bool
    
    init(
        regulation: String,
        isExpanded: Binding<Bool>
    ) {
        switch regulation.isEmpty {
        case true:
            self.sentences = []
        case false:
            self.sentences = regulation
                .components(separatedBy: "\n")
                .map { $0.replacingOccurrences(of: "- ", with: "") }
                .filter { !$0.isEmpty }
        }
        self._isExpanded = isExpanded
    }
    
    var body: some View {
        Group {
            switch sentences.isEmpty {
            case true:
                EmptyInfoView(title: "반입 규정")
            case false:
                VStack(spacing: 0) {
                    headerView
                    descriptionView
                        .renderedIf(isExpanded)
                }
                .background(Color.background2)
                .clipShape(RoundedRectangle(cornerRadius: 10))
            }
        }
    }
}

private extension RegulationInfoView {
    var headerView: some View {
        Button {
            isExpanded.toggle()
        } label: {
            HStack {
                Text("반입 규정")
                    .pretendard(style: .body3)
                    .foregroundStyle(Color.point1)
                    .padding(.leading, 16)
                
                Spacer()
                
                Image.iconTriangle
                    .renderingMode(.template)
                    .resizable()
                    .frame(width: 24, height: 24)
                    .foregroundStyle(Color.grey3)
                    .rotationEffect(.degrees(isExpanded ? 0 : 180))
                    .padding(.horizontal, 16)
                    .padding(.vertical, 12)
            }
        }
    }
    
    var descriptionView: some View {
        VStack(spacing: 20) {
            ForEach(0..<sentences.count, id: \.self) { index in
                sentenceView(sentences[index])
            }
        }
        .padding(.horizontal, 16)
        .padding(.bottom , 12)
    }
    
    func sentenceView(_ sentence: String) -> some View {
        HStack(alignment: .top, spacing: 0) {
            Text("•")
                .pretendard(style: .body5)
                .foregroundStyle(Color.grey1)
                .padding(.horizontal, 8)
            
            Text(sentence)
                .pretendard(style: .body5)
                .foregroundStyle(Color.grey1)
                .multilineTextAlignment(.leading)
                .frame(maxWidth: .infinity, alignment: .leading)
        }
    }
}

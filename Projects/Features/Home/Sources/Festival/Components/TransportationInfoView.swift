//
//  TransportationInfoView.swift
//  Home
//
//  Created by 이정원 on 7/1/25.
//  Copyright © 2025 Darayo. All rights reserved.
//

import SwiftUI
import DesignSystem
import Domain

struct TransportationInfoView: View {
    private let sentences: [String]
    
    init(transportationInfo: String) {
        switch transportationInfo.isEmpty {
        case true:
            self.sentences = []
        case false:
            self.sentences = transportationInfo
                .components(separatedBy: "\n")
                .map { $0.replacingOccurrences(of: "- ", with: "") }
                .filter { !$0.isEmpty }
        }
    }
    
    var body: some View {
        Group {
            switch sentences.isEmpty {
            case true: EmptyInfoView(title: "교통 안내")
            case false:
                VStack(spacing: 12) {
                    titleView
                    descriptionView
                }
                .padding(.horizontal, 16)
                .padding(.vertical, 12)
                .background(Color.background2)
                .clipShape(RoundedRectangle(cornerRadius: 8))
            }
        }
    }
}

private extension TransportationInfoView {
    func icon(type: TransportationType) -> Image {
        switch type {
        case .subway: .iconSubway
        case .bus: .iconBus
        }
    }
}

private extension TransportationInfoView {
    var titleView: some View {
        Text("교통 안내")
            .pretendard(style: .body3)
            .foregroundStyle(Color.point1)
            .frame(maxWidth: .infinity, alignment: .leading)
    }
    
    var descriptionView: some View {
        VStack(spacing: 20) {
            ForEach(0..<sentences.count, id: \.self) { index in
                sentenceView(sentences[index])
            }
        }
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

//
//  StageHeaderView.swift
//  DesignSystem
//
//  Created by 이정원 on 6/17/25.
//  Copyright © 2025 Darayo. All rights reserved.
//

import SwiftUI

struct StageHeaderView: View {
    private let stages: [String]
    
    init(stages: [String]) {
        self.stages = stages
    }
    
    var body: some View {
        HStack(spacing: 8) {
            ForEach(0..<stages.count, id: \.self) { index in
                let stage = stages[index]
                
                if stages.count > 3 {
                    stageview(stage: stage)
                        .frame(width: 86)
                } else {
                    stageview(stage: stage)
                        .frame(maxWidth: .infinity)
                }
            }
        }
        .padding(.horizontal, 8)
    }
}

private extension StageHeaderView {
    func stageview(stage: String) -> some View {
        Text(stage)
            .pretendard(style: .body4)
            .foregroundStyle(Color.white)
            .frame(height: 34)
    }
}

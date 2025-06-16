//
//  TimetableView.swift
//  DesignSystem
//
//  Created by 이정원 on 6/16/25.
//  Copyright © 2025 Darayo. All rights reserved.
//

import SwiftUI

public struct TimetableView: View {
    private let rows = 20  // 시간 (예: 시간대)
    private let columns = 7  // 요일
    
    public init() {}
    
    public var body: some View {
        ScrollView([.horizontal, .vertical]) {
            LazyVStack(spacing: 1) {
                ForEach(0..<rows, id: \.self) { row in
                    LazyHStack(spacing: 1) {
                        ForEach(0..<columns, id: \.self) { column in
                            Rectangle()
                                .fill(Color.blue.opacity(0.2))
                                .frame(width: 80, height: 60)
                                .overlay(
                                    Text("R\(row)C\(column)")
                                        .font(.caption)
                                )
                        }
                    }
                }
            }
            .padding()
        }
    }
}

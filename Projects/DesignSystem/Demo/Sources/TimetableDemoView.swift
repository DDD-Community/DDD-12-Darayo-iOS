//
//  TimetableDemoView.swift
//  DesignSystemDemo
//
//  Created by 이정원 on 6/16/25.
//  Copyright © 2025 Darayo. All rights reserved.
//

import SwiftUI
import DesignSystem

struct TimetableDemoView: View {
    @State private var columnCount: Int = 1
    
    var body: some View {
        VStack(spacing: 0) {
            button
            TimetableView(timetable: timetable)
        }
        .background(Color.background1)
        .toolbarBackground(.visible, for: .navigationBar)
        .toolbarBackground(Color.background1, for: .navigationBar)
    }
}

private extension TimetableDemoView {
    var button: some View {
        Button {
            columnCount = columnCount % 4 + 1
        } label: {
            Text("Stage 개수 변경")
                .pretendard(style: .title4)
                .foregroundStyle(Color.white)
        }
        .frame(maxWidth: .infinity)
        .frame(height: 48)
        .background(Color.grey6)
    }
    
    var timetable: Timetable {
        Timetable(stages: stages, schedules: schedules)
    }
    
    var stages: [String] {
        let alphabets: [String] = ["A", "B", "C", "D"]
        
        return (0..<columnCount).map {
            return "\(alphabets[$0]) stage"
        }
    }
    
    var schedules: [[Timetable.Schedule]] {
        (0..<columnCount).map {
            makeOneDaySchedule(column: $0)
        }
    }
    
    func makeOneDaySchedule(column: Int) -> [Timetable.Schedule] {
        var base = 840
        if column % 2 == 0 { base += 30 }
        
        return (0..<6).map { index in
            let start = base + 90 * index
            let end = start + 60
            return .init(
                start: .init(value: start),
                end: .init(value: end),
                artistName: "아티스트명"
            )
        }
    }
}

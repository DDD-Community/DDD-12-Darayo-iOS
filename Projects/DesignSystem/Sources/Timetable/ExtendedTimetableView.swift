//
//  ExtendedTimetableView.swift
//  DesignSystem
//
//  Created by 이정원 on 7/8/25.
//  Copyright © 2025 Darayo. All rights reserved.
//

import SwiftUI

public struct ExtendedTimetableView: View {
    private let timetable: Timetable
    
    public init(timetable: Timetable) {
        self.timetable = timetable
    }
    
    public var body: some View {
        VStack(spacing: 0) {
            dayHeaderView
            VStack(spacing: 1) {
                HStack(spacing: 1) {
                    Spacer()
                        .frame(width: 50)
                    StageHeaderView(stages: timetable.stages)
                }
                
                HStack(alignment: .top, spacing: 1) {
                    TimeHeaderView(
                        start: timetable.schedules.start.hour,
                        end: timetable.schedules.end.hour
                    )
                    TimetableGridView(schedules: timetable.schedules)
                }
            }
            .overlay(alignment: .topLeading) { verticalBorder }
            .overlay(alignment: .topLeading) { horizontalBorder }
        }
    }
}

private extension ExtendedTimetableView {
    var dayHeaderView: some View {
        Text("25.08.08 (금)")
            .pretendard(style: .title4)
            .frame(maxWidth: .infinity)
            .frame(height: 48)
            .background(Color.background2)
    }
    
    var verticalBorder: some View {
        Color.grey6
            .frame(width: 1)
            .frame(maxHeight: .infinity)
            .padding(.leading, 50)
    }
    
    var horizontalBorder: some View {
        Color.grey6
            .frame(maxWidth: .infinity)
            .frame(height: 1)
            .padding(.leading, 50)
            .padding(.top, 34)
    }
}



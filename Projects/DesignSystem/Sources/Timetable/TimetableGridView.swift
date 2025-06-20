//
//  TimetableGridView.swift
//  DesignSystem
//
//  Created by 이정원 on 6/17/25.
//  Copyright © 2025 Darayo. All rights reserved.
//

import SwiftUI

struct TimetableGridView: View {
    private let schedules: [[Timetable.Schedule]]
    
    init(schedules: [[Timetable.Schedule]]) {
        self.schedules = schedules
    }
    
    var body: some View {
        ZStack(alignment: .top) {
            gridBackgroundView
            
            HStack(alignment: .top, spacing: 8) {
                ForEach(0..<schedules.count, id: \.self) { index in
                    let stageSchedules = schedules[index]
                    ZStack(alignment: .top) {
                        ForEach(0..<stageSchedules.count, id: \.self) { index in
                            let schedule = stageSchedules[index]
                            
                            if schedules.count > 3 {
                                scheduleView(schedule: schedule)
                                    .frame(width: 86)
                            } else {
                                scheduleView(schedule: schedule)
                                    .frame(maxWidth: .infinity)
                            }
                        }
                    }
                }
            }
            .padding(.horizontal, 8)
        }
        .padding(.top, 1)
    }
}

private extension TimetableGridView {
    var gridBackgroundView: some View {
        VStack(spacing: 0) {
            let end = schedules.end.hour
            let start = schedules.start.hour
            let count = (end - start) * 6
            
            ForEach(1...count, id: \.self) { index in
                Spacer()
                    .frame(height: 15)
                
                if index % 6 == 0 { solidLine }
                else { dashedLine }
            }
        }
        .frame(height: totalHeight)
    }
    
    var solidLine: some View {
        Color.grey6
            .frame(height: 1)
    }
    
    var dashedLine: some View {
        let strokeStyle = StrokeStyle(
            lineWidth: 1,
            lineCap: .round,
            dash: [3, 4]
        )
        
        return Line()
            .stroke(Color.grey6, style: strokeStyle)
    }
    
    func scheduleView(schedule: Timetable.Schedule) -> some View {
        VStack {
            Text(schedule.artistName)
                .pretendard(style: .body3)
                .foregroundStyle(Color.white)
                .frame(maxWidth: .infinity, alignment: .leading)
            
            Spacer()
            Text(timeString(of: schedule))
                .pretendard(style: .caption2)
                .foregroundStyle(Color.white)
                .frame(maxWidth: .infinity, alignment: .leading)
        }
        .padding(8)
        .frame(height: height(of: schedule))
        .background(Color.point2.opacity(0.4))
        .clipShape(RoundedRectangle(cornerRadius: 4))
        .overlay(RoundedRectangle(cornerRadius: 4).stroke(Color.point2))
        .padding(.top, offset(of: schedule))
    }
}

private extension TimetableGridView {
    func offset(of schedule: Timetable.Schedule) -> CGFloat {
        let start = schedules.start.value
        let scheduleStart = schedule.start.value
        return CGFloat(scheduleStart - start) * 1.6
    }
    
    func height(of schedule: Timetable.Schedule) -> CGFloat {
        let end = schedule.end.value
        let start = schedule.start.value
        return CGFloat(end - start) * 1.6
    }
    
    func timeString(of schedule: Timetable.Schedule) -> String {
        let startHour = schedule.start.hour.toString
        let startMinute = schedule.start.minute.toString
        let endHour = schedule.end.hour.toString
        let endMinute = schedule.end.minute.toString
        return "\(startHour):\(startMinute)-\(endHour):\(endMinute)"
    }
    
    var totalHeight: CGFloat {
        let end = schedules.end.value
        let start = schedules.start.value
        return CGFloat(end - start) * 1.6
    }
}

private extension Int {
    var toString: String {
        String(format: "%02d", self)
    }
}

private struct Line: Shape {
    func path(in rect: CGRect) -> Path {
        var path = Path()
        path.move(to: CGPoint(x: rect.minX, y: rect.midY))
        path.addLine(to: CGPoint(x: rect.maxX, y: rect.midY))
        return path
    }
}

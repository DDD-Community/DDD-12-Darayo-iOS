//
//  Timetable.swift
//  DesignSystem
//
//  Created by 이정원 on 6/19/25.
//  Copyright © 2025 Darayo. All rights reserved.
//

public struct Timetable {
    let stages: [String]
    let schedules: [[Schedule]]
    
    public init(
        stages: [String],
        schedules: [[Schedule]]
    ) {
        self.stages = stages
        self.schedules = schedules
    }
}

extension Timetable {
    public struct Schedule {
        let start: Time
        let end: Time
        let artistName: String
        
        public init(
            start: Time,
            end: Time,
            artistName: String
        ) {
            self.start = start
            self.end = end
            self.artistName = artistName
        }
    }
}

extension Timetable {
    public struct Time {
        let value: Int
        
        public init(value: Int) {
            self.value = value
        }
        
        public init(hour: Int, minute: Int) {
            self.value = hour * 60 + minute
        }
        
        var hour: Int { value / 60 }
        var minute: Int { value % 60 }
    }
}

extension [[Timetable.Schedule]] {
    var start: Timetable.Time {
        let value = compactMap { $0.first?.start.value }.min()
        guard let value else { return .init(hour: 9, minute: 0) }
        let time = Timetable.Time(value: value)
        return .init(hour: time.hour, minute: 0)
    }
    
    var end: Timetable.Time {
        let value = compactMap { $0.last?.end.value }.max()
        guard let value else { return .init(hour: 24, minute: 0) }
        let time = Timetable.Time(value: value)
        return .init(hour: time.hour + 1, minute: 0)
    }
}

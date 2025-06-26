//
//  DummyEventData.swift
//  DesignSystemDemo
//
//  Created by 이다영 on 6/26/25.
//  Copyright © 2025 Darayo. All rights reserved.
//

import Foundation
import DesignSystem

enum DummyEventData {
    static let events: [CalendarModel.Event] = [
        CalendarModel.Event(
            title: "페스티벌명 최대 1줄",
            location: "예매처 인터파크",
            date: Foundation.Calendar.current.date(from: DateComponents(year: 2025, month: 6, day: 26))!,
            time: "25.06.12 18:00",
            category: "예매일"
        ),
        CalendarModel.Event(
            title: "페스티벌명 최대 1줄",
            location: "장소 인천 송도 달빛광장",
            date: Foundation.Calendar.current.date(from: DateComponents(year: 2025, month: 6, day: 26))!,
            time: "25.08.01 - 25.08.03",
            category: "행사일"
        ),
        CalendarModel.Event(
            title: "여름 음악 페스티벌",
            location: "장소 서울 올림픽공원",
            date: Foundation.Calendar.current.date(from: DateComponents(year: 2025, month: 6, day: 28))!,
            time: "25.07.15 19:00",
            category: "예매일"
        ),
        CalendarModel.Event(
            title: "록 페스티벌 2025",
            location: "장소 부산 해운대",
            date: Foundation.Calendar.current.date(from: DateComponents(year: 2025, month: 6, day: 30))!,
            time: "25.09.10 - 25.09.12",
            category: "행사일"
        )
    ]
}

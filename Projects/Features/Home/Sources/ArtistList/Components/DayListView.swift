//
//  DayListView.swift
//  Home
//
//  Created by 이정원 on 7/2/25.
//  Copyright © 2025 Darayo. All rights reserved.
//

import SwiftUI
import DesignSystem

struct DayListView: View {
    private let totalDays: Int
    private let selectedDay: Int
    private let action: (Int) -> Void
    
    @State private var width: CGFloat = .infinity

    init(
        totalDays: Int,
        selectedDay: Int,
        action: @escaping (Int) -> Void
    ) {
        self.totalDays = totalDays
        self.selectedDay = selectedDay
        self.action = action
    }
    
    var body: some View {
        GeometryReader { proxy in
            let canScroll = canScroll(proxy.size.width)
            
            if canScroll {
                ScrollViewReader { proxy in
                    ScrollView(.horizontal) {
                        dayListView(canScroll: canScroll)
                    }
                    .scrollIndicators(.hidden)
                    .onChange(of: selectedDay) { _, day in
                        withAnimation {
                            proxy.scrollTo(day, anchor: .center)
                        }
                    }
                }
            } else {
                dayListView(canScroll: canScroll)
            }
        }
    }
}

private extension DayListView {
    func canScroll(_ width: CGFloat) -> Bool {
        if self.width == .infinity { return true }
        return Int(self.width) > Int(width)
    }
}

private extension DayListView {
    func dayListView(canScroll: Bool) -> some View {
        HStack(spacing: canScroll ? 12 : 0) {
            ForEach(1...totalDays, id: \.self) { day in
                Button {
                    action(day)
                } label: {
                    switch canScroll {
                    case true:
                        textView(day)
                    case false:
                        textView(day)
                            .frame(maxWidth: .infinity)
                    }
                }
                .id(day)
            }
        }
        .frame(height: 20.8)
        .padding(.vertical, 16)
        .background(backgroundView)
    }
    
    func textView(_ day: Int) -> some View {
        let isSelected = day == selectedDay
        
        return Text("DAY\(day)")
            .pretendard(style: .title3)
            .foregroundStyle(isSelected ? Color.point1 : Color.grey4)
            .padding(.horizontal, 16)
    }
    
    var backgroundView: some View {
        GeometryReader { proxy in
            Color.clear.preference(
                key: ContentWidthkey.self,
                value: proxy.size.width
            )
        }
        .onPreferenceChange(ContentWidthkey.self) { width in
            self.width = width
        }
    }
}

private struct ContentWidthkey: PreferenceKey {
    static var defaultValue: CGFloat = 0
    
    static func reduce(value: inout CGFloat, nextValue: () -> CGFloat) {
        value = max(value, nextValue())
    }
}

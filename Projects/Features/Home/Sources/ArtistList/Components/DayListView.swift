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
    private let selectedIndex: Int
    private let containsNil: Bool
    private let action: (Int) -> Void
    
    @State private var width: CGFloat = .infinity
    private let height: CGFloat = 20.8

    init(
        totalDays: Int,
        selectedIndex: Int,
        containsNil: Bool,
        action: @escaping (Int) -> Void
    ) {
        self.totalDays = totalDays
        self.selectedIndex = selectedIndex
        self.containsNil = containsNil
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
                    .onChange(of: selectedIndex) { _, index in
                        withAnimation {
                            proxy.scrollTo(index, anchor: .center)
                        }
                    }
                }
            } else {
                dayListView(canScroll: canScroll)
            }
        }
        .frame(height: height + 32)
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
            ForEach(0..<totalDays, id: \.self) { index in
                Button {
                    action(index)
                } label: {
                    switch canScroll {
                    case true:
                        textView(index)
                    case false:
                        textView(index)
                            .frame(maxWidth: .infinity)
                    }
                }
                .id(index)
            }
        }
        .frame(height: height)
        .padding(.vertical, 16)
        .background(backgroundView)
    }
    
    func textView(_ index: Int) -> some View {
        let isSelected = index == selectedIndex
        let text = switch index == totalDays - 1 && containsNil {
        case true: "일정 미정"
        case false: "DAY\(index + 1)"
        }
        
        return Text(text)
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

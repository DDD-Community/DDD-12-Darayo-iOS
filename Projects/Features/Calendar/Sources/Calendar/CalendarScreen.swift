//
//  CalendarScreen.swift
//  Home
//
//  Created by 이정원 on 6/29/25.
//  Copyright © 2025 Darayo. All rights reserved.
//

import SwiftUI
import ComposableArchitecture
import DesignSystem
import Domain

public struct CalendarScreen: View {
    @Bindable private var store: StoreOf<CalendarFeature>

    public init(store: StoreOf<CalendarFeature>) {
        self.store = store
    }

    public var body: some View {
        ZStack {
            Color.background1.ignoresSafeArea()
            VStack(spacing: 0) {
                navigationBar
                CalendarSegmentedControl(
                    selectedMode: Binding(
                        get: { store.selectedMode },
                        set: { store.send(.modeChanged($0)) }
                    )
                )
                
                ScrollView {
                    VStack(spacing: 0) {
                        calendarSection
                            .padding(.top, 16)
                        
                        eventListSection
                            .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .top)
                            .padding(.top, 20)
                    }
                }
            }
        }
        .onAppear {
            store.send(.onAppear)
        }
    }
}

private extension CalendarScreen {
    var navigationBar: some View {
        HStack {
            Image.logo
            Spacer()
            Button {
                store.send(.delegate(.openMyPage))
            } label: {
                Image.iconMyPage
                    .renderingMode(.template)
                    .resizable()
                    .frame(width: 24, height: 24)
                    .foregroundStyle(Color.grey4)
            }
        }
        .padding(.vertical, 10)
        .padding(.horizontal, 16)
    }
    
    var calendarSection: some View {
        CalendarView(
            calendarEvents: store.allCalendarEvents,
            selectedDate: store.selectedDate,
            onDateSelected: { date in
                store.send(.dateSelected(date))
            },
            onMonthChanged: { _ in }
        )
    }

    var eventListSection: some View {
        EventListView(
            events: store.eventsForSelectedDate,
            title: nil,
            onTap: { event in
                store.send(.eventTapped(festivalId: event.festivalId))
            }
        )
    }
}

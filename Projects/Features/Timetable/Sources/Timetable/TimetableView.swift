//
//  TimetableView.swift
//  Timetable
//
//  Created by 이정원 on 6/23/25.
//  Copyright © 2025 Darayo. All rights reserved.
//

import SwiftUI
import ComposableArchitecture
import DesignSystem

public struct TimetableView: View {
    @Bindable private var store: StoreOf<TimetableFeature>
    
    public init(store: StoreOf<TimetableFeature>) {
        self.store = store
    }
    
    public var body: some View {
        VStack(spacing: 0) {
            navigationBar
            dateHeaderView
            timetableView
        }
        .background(Color.background1)
        .sheet(
            item: $store.scope(state: \.path, action: \.path)
        ) { store in
            switch store.case {
            case .selectFestival(let store):
                SelectFestivalView(store: store)
            case .selectArtist(let store):
                SelectArtistView(store: store)
            }
        }
    }
}

private extension TimetableView {
    var navigationBar: some View {
        HStack {
            festivalButton
            Spacer()
            HStack(spacing: 20) {
                filterButton
                downloadButton
            }
        }
        .padding(.horizontal, 16)
        .frame(height: 56)
    }
    
    var festivalButton: some View {
        Button {
            store.send(.festivalButtonTapped)
        } label: {
            HStack(spacing: 2) {
                Text(store.festivalName)
                    .pretendard(style: .title2)
                    .foregroundStyle(Color.white)
                
                Image.iconDown
                    .renderingMode(.template)
                    .resizable()
                    .frame(width: 24, height: 24)
                    .foregroundStyle(Color.white)
            }
        }
    }
    
    var filterButton: some View {
        Button {
            store.send(.filterButtonTapped)
        } label: {
            Image.iconFilter
                .renderingMode(.template)
                .resizable()
                .frame(width: 24, height: 24)
                .foregroundStyle(Color.white)
        }
    }
    
    var downloadButton: some View {
        Button {
            
        } label: {
            Image.iconDownload
                .renderingMode(.template)
                .resizable()
                .frame(width: 24, height: 24)
                .foregroundStyle(Color.white)
        }
    }
    
    var dateHeaderView: some View {
        HStack(spacing: 0) {
            Button {
                
            } label: {
                Image.iconChevronLeft
                    .renderingMode(.template)
                    .resizable()
                    .frame(width: 24, height: 24)
                    .foregroundStyle(Color.white)
                    .padding(.horizontal, 16)
                    .padding(.vertical, 12)
            }
            
            Text(store.dateString)
                .pretendard(style: .title4)
                .foregroundStyle(Color.white)
                .frame(maxWidth: .infinity)
            
            Button {
                
            } label: {
                Image.iconChevronRight
                    .renderingMode(.template)
                    .resizable()
                    .frame(width: 24, height: 24)
                    .foregroundStyle(Color.white)
                    .padding(.horizontal, 16)
                    .padding(.vertical, 12)
            }
        }
        .background(Color.grey6)
    }
    
    var timetableView: some View {
        DesignSystem.TimetableView(timetable: timetable)
    }
}

// MARK: Dummy Data
private extension TimetableView {
    var timetable: Timetable {
        Timetable(stages: stages, schedules: schedules)
    }
    
    var stages: [String] {
        let alphabets: [String] = ["A", "B", "C", "D"]
        
        return (0..<4).map {
            return "\(alphabets[$0]) stage"
        }
    }
    
    var schedules: [[Timetable.Schedule]] {
        (0..<4).map {
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

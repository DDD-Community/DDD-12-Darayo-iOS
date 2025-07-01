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
    private let store: StoreOf<TimetableFeature>
    
    public init(store: StoreOf<TimetableFeature>) {
        self.store = store
    }
    
    public var body: some View {
        VStack {
            Spacer()
            Text("타임테이블")
                .pretendard(style: .title1)
                .foregroundStyle(Color.white)
                .padding(.bottom, 24)
            Spacer()
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .background(Color.background1)
    }
}

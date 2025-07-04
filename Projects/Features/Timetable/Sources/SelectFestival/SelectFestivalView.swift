//
//  SelectFestivalView.swift
//  Timetable
//
//  Created by 이정원 on 7/4/25.
//  Copyright © 2025 Darayo. All rights reserved.
//

import SwiftUI
import ComposableArchitecture
import DesignSystem

public struct SelectFestivalView: View {
    @Bindable private var store: StoreOf<SelectFestivalFeature>
    
    public init(store: StoreOf<SelectFestivalFeature>) {
        self.store = store
    }
    
    public var body: some View {
        VStack(spacing: 0) {
            navigationBar
            festivalPicker
            doneButton
        }
        .padding(.horizontal, 16)
        .padding(.top, 24)
        .padding(.bottom, 16)
        .background(Color.background2)
        .presentationDetents([.medium])
    }
}

private extension SelectFestivalView {
    var navigationBar: some View {
        ZStack(alignment: .trailing) {
            Text("페스티벌 목록")
                .pretendard(style: .title1)
                .frame(maxWidth: .infinity)
            
            Button {
                store.send(.closeButtonTapped)
            } label: {
                Image.iconClose
                    .resizable()
                    .frame(width: 24, height: 24)
            }
        }
    }
    
    var festivalPicker: some View {
        Picker("", selection: $store.selectedFestival) {
            ForEach(store.festivals, id: \.self) { festival in
                Text(festival)
                    .pretendard(style: .title2)
            }
        }
        .pickerStyle(.wheel)
        .frame(maxHeight: .infinity)
    }
    
    var doneButton: some View {
        Button("선택완료") {
            store.send(.doneButtonTapped)
        }
        .buttonStyle(.festibee)
    }
}

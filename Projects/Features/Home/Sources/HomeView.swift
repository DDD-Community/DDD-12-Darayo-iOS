//
//  HomeView.swift
//  Home
//
//  Created by 이정원 on 6/22/25.
//  Copyright © 2025 Darayo. All rights reserved.
//

import SwiftUI
import ComposableArchitecture
import DesignSystem

public struct HomeView: View {
    @Bindable private var store: StoreOf<HomeFeature>
    
    public init(store: StoreOf<HomeFeature>) {
        self.store = store
    }
    
    public var body: some View {
        VStack(spacing: 0) {
            navigationBar
            ScrollView {
                VStack {
                    Text("홈")
                        .pretendard(style: .title1)
                        .foregroundStyle(Color.white)
                }
                .padding(.bottom, 24)
            }
        }
        .background(Color.background1)
    }
}

private extension HomeView {
    var navigationBar: some View {
        VStack(alignment: .leading, spacing: 0) {
            HStack {
                logo
                Spacer()
                displayModeView(mode: $store.displayMode)
            }
            .padding(.vertical, 10)
            
            favoritesButton(isFiltered: $store.isFiltered)
        }
        .padding(.horizontal, 16)
        .padding(.bottom, 10)
    }
    
    var logo: some View {
        Text("FESTIBEE")
            .pretendard(style: .title1)
            .foregroundStyle(Color.white)
        
    }
    
    func displayModeView(mode: Binding<HomeFeature.DisplayMode>) -> some View {
        return HStack(spacing: 15) {
            displayModebutton(mode: .grid) {
                mode.wrappedValue = .grid
            }
            
            displayModebutton(mode: .calendar) {
                mode.wrappedValue = .calendar
            }
        }
    }
    
    func displayModebutton(
        mode: HomeFeature.DisplayMode,
        action: @escaping () -> Void
    ) -> some View {
        let color: Color = mode == store.displayMode ? .white : .grey4
        return Button(action: action) {
            let image: Image = switch mode {
            case .grid: Image.iconGridMode
            case .calendar: Image.iconCalendarMode
            }
            
            image
                .renderingMode(.template)
                .resizable()
                .frame(width: 24, height: 24)
                .foregroundStyle(color)
        }
        .buttonStyle(.plain)
    }
    
    func favoritesButton(isFiltered: Binding<Bool>) -> some View {
        let icon: Image = switch isFiltered.wrappedValue {
        case true: Image.iconChecked
        case false: Image.iconUnchecked
        }
        
        return Button {
            isFiltered.wrappedValue.toggle()
        } label: {
            HStack(spacing: 2) {
                icon
                    .resizable()
                    .frame(width: 24, height: 24)
                
                Text("좋아요한 페스티벌")
                    .pretendard(style: .body4)
                    .foregroundStyle(Color.grey3)
            }
        }
        .buttonStyle(.plain)
    }
}

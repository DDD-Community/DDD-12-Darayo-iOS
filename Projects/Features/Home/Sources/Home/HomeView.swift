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
            ZStack {
                HomeGridView(store: store)
                    .opacity(opacity(.grid))
                
                HomeCalendarView(store: store)
                    .opacity(opacity(.calendar))
            }
        }
        .background(Color.background1)
    }
}

private extension HomeView {
    func opacity(_ mode: HomeFeature.DisplayMode) -> CGFloat {
        mode == store.displayMode ? 1 : 0
    }
    
    var navigationBar: some View {
        HStack {
            Image.logo
            Spacer()
            displayModeView(mode: $store.displayMode)
        }
        .padding(.vertical, 10)
        .padding(.horizontal, 16)
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
}

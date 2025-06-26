//
//  MainView.swift
//  Root
//
//  Created by 이정원 on 6/21/25.
//  Copyright © 2025 Darayo. All rights reserved.
//

import SwiftUI
import ComposableArchitecture
import DesignSystem
import Home
import Timetable
import MyPage

public struct MainView: View {
    @Bindable private var store: StoreOf<MainFeature>
    
    public init(store: StoreOf<MainFeature>) {
        UITabBar.appearance().isHidden = true
        self.store = store
    }
    
    public var body: some View {
        GeometryReader { proxy in
            ZStack(alignment: .bottom) {
                let hasBottomSafeArea = proxy.safeAreaInsets.bottom > 0
                let tabBarHeight: CGFloat = hasBottomSafeArea ? 90 : 69
                
                tabView(bottomPadding: tabBarHeight - 24)
                tabBar(height: tabBarHeight)
            }
            .ignoresSafeArea(edges: .bottom)
        }
    }
}

private extension MainView {
    func icon(tab: MainFeature.Tab) -> Image {
        switch tab {
        case .home: Image.iconHome
        case .timetable: Image.iconTimetable
        case .myPage: Image.iconMyPage
        }
    }
}

private extension MainView {
    func tabView(bottomPadding: CGFloat) -> some View {
        TabView {
            Group {
                switch store.currentTab {
                case .home:
                    let store = store.scope(state: \.home, action: \.home)
                    HomeView(store: store)
                case .timetable:
                    let store = store.scope(state: \.timetable, action: \.timetable)
                    TimetableView(store: store)
                case .myPage:
                    let store = store.scope(state: \.myPage, action: \.myPage)
                    MyPageView(store: store)
                }
            }
            .padding(.bottom, bottomPadding)
            .ignoresSafeArea(edges: .bottom)
        }
    }
    
    func tabBar(height: CGFloat) -> some View {
        HStack(alignment: .top, spacing: 0) {
            ForEach(MainFeature.Tab.allCases, id: \.self) { tab in
                tabButton(tab: tab)
            }
        }
        .padding(.horizontal, 18)
        .frame(height: height)
        .background(Color.black)
        .clipShape(RoundedCorner(radius: 20, corners: [.topLeft, .topRight]))
    }
    
    func tabButton(tab: MainFeature.Tab) -> some View {
        Button{
            store.send(.binding(.set(\.currentTab, tab)))
        } label: {
            VStack(spacing: 1) {
                let isSelected = tab == store.currentTab
                let color: Color = isSelected ? .point1 : .grey4
                
                icon(tab: tab)
                    .resizable()
                    .renderingMode(.template)
                    .frame(width: 24, height: 24)
                    .foregroundStyle(color)
                
                Text(tab.name)
                    .pretendard(style: .caption1)
                    .foregroundStyle(color)
                
                Spacer()
            }
            .frame(maxWidth: .infinity)
            .padding(.top, 14)
            .contentShape(Rectangle())
        }
        .buttonStyle(.plain)
    }
}

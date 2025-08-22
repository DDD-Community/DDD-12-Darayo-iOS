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
import Base

public struct MainView: View {
    @Bindable private var store: StoreOf<MainFeature>
    @Environment(\.openURL) private var openURL
    @Environment(\.scenePhase) private var scenePhase
    
    public init(store: StoreOf<MainFeature>) {
        UITabBar.appearance().isHidden = true
        self.store = store
    }
    
    public var body: some View {
        NavigationStack(
            path: $store.scope(state: \.path, action: \.path)
        ) {
           mainView
        } destination: { store in
            switch store.case {
            case .festival(let store): FestivalView(store: store)
            case .artistList(let store): ArtistListView(store: store)
            case .myPage(let store): MyPageView(store: store)
            case .likedFestivals(let store): LikedFestivalsView(store: store)
            case .subscribedFestivals(let store): SubscribedFestivalsView(store: store)
            case .termsOfService(let store): TermsOfServiceView(store: store)
            case .privacyPolicy(let store): PrivacyPolicyView(store: store)
            }
        }
        .safari(url: $store.url)
        .onAppear { store.send(.onAppear) }
        .onChange(of: store.shouldOpenURL) { oldValue, newValue in
            guard !oldValue, newValue else { return }
            store.send(.binding(.set(\.shouldOpenURL, false)))
            guard let url = URL(string: UIApplication.openSettingsURLString) else { return }
            openURL(url)
        }
        .onChange(of: scenePhase) { oldValue, newValue in
            guard oldValue == .background else { return }
            store.send(.enteredForeground)
        }
    }
}

private extension MainView {
    func icon(tab: MainFeature.Tab) -> Image {
        switch tab {
        case .home: Image.iconHome
        }
    }
}

private extension MainView {
    var mainView: some View {
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
    
    func tabView(bottomPadding: CGFloat) -> some View {
        TabView(selection: $store.currentTab) {
            HomeView(store: store.scope(state: \.home, action: \.home))
                .tag(MainFeature.Tab.home)
        }
        .padding(.bottom, bottomPadding)
        .ignoresSafeArea(edges: .bottom)
        
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
    }
}

extension MainFeature.AlertCase: AlertPresentable {
    public var alertInfo: AlertInfo {
        switch self {
        case .home(let alertCase): return alertCase.alertInfo
        case .myPage(let alertCase): return alertCase.alertInfo
        case .subscribedFestivals(let alertCase): return alertCase.alertInfo
        case .error: return .error
        }
    }
}

//
//  MyPageView.swift
//  MyPage
//
//  Created by 이정원 on 6/23/25.
//  Copyright © 2025 Darayo. All rights reserved.
//

import SwiftUI
import ComposableArchitecture
import DesignSystem
import Base

public struct MyPageView: View {
    @Bindable private var store: StoreOf<MyPageFeature>
    @Environment(\.scenePhase) private var scenePhase
    @Environment(\.openURL) private var openURL
    
    public init(store: StoreOf<MyPageFeature>) {
        self.store = store
    }
    
    public var body: some View {
        VStack(spacing: 0) {
            navigationBar
            ScrollView {
                VStack(spacing: 0) {
                    buttonSection
                    VStack(spacing: 16) {
                        notificationSection
                        appInfoSection
                    }
                    updateInfoSection
                }
            }
        }
        .navigationBarBackButtonHidden()
        .background(Color.background1)
        .customAlert($store.scope(state: \.alert, action: \.alert))
        .onAppear { store.send(.onAppear) }
        .onChange(of: scenePhase) { oldValue, _ in
            guard oldValue == .background else { return }
            store.send(.enteredForeground)
        }
        .onChange(of: store.shouldOpenURL) { oldValue, newValue in
            guard !oldValue, newValue else { return }
            store.send(.binding(.set(\.shouldOpenURL, false)))
            guard let url = URL(string: UIApplication.openSettingsURLString) else { return }
            openURL(url)
        }
    }
}

private extension MyPageView {
    func title(of menu: MyPageFeature.Menu) -> String {
        switch menu {
        case .inquiry: "1:1 문의하기"
        case .termsOfService: "이용약관"
        case .privacyPolicy: "개인정보 처리방침"
        }
    }
}

private extension MyPageView {
    var navigationBar: some View {
        ZStack(alignment: .leading) {
            Text("MY")
                .pretendard(style: .title2)
                .foregroundStyle(Color.white)
                .frame(maxWidth: .infinity)
            
            Button {
                store.send(.backButtonTapped)
            } label: {
                Image.iconArrowLeft
                    .renderingMode(.template)
                    .resizable()
                    .frame(width: 24, height: 24)
                    .foregroundStyle(Color.white)
                    .padding(16)
            }
        }
    }
    
    var buttonSection: some View {
        HStack(spacing: 9) {
            festivalListButton(
                image: Image.iconHeart,
                count: store.likedFestivals.count,
                title: "좋아요한 페스티벌"
            ) {
                store.send(.likedFestivalsButtonTapped)
            }
            
            festivalListButton(
                image: Image.iconNotification,
                count: store.subscribedFestivals.count,
                title: "알림 설정한 페스티벌"
            ) {
                store.send(.subscribedFestivalsButtonTapped)
            }
        }
        .padding(.horizontal, 16)
        .padding(.top, 20)
        .padding(.bottom, 24)
    }
    
    var notificationSection: some View {
        VStack(spacing: 0) {
            menuTitleView("알림")
            notificationToggleView
            divider
        }
    }
    
    var appInfoSection: some View {
        VStack(spacing: 0) {
            let allMenuList = MyPageFeature.Menu.allCases
            menuTitleView("앱 정보")
            ForEach(allMenuList, id: \.self) { menu in
                VStack(spacing: 0) {
                    menuButton(menu) { store.send(.menuTapped(menu)) }
                    divider
                }
            }
        }
    }
    
    func festivalListButton(
        image: Image,
        count: Int,
        title: String,
        action: @escaping () -> Void
    ) -> some View {
        Button(action: action) {
            VStack(spacing: 8) {
                HStack(spacing: 8) {
                    image
                        .renderingMode(.template)
                        .resizable()
                        .frame(width: 28, height: 28)
                        .foregroundStyle(Color.point1)
                    
                    Text(String(count))
                        .pretendard(style: .title2)
                        .foregroundStyle(Color.point1)
                        .opacity(store.isLoading ? 0 : 1)
                }
                
                Text(title)
                    .pretendard(style: .caption1)
                    .foregroundStyle(Color.white)
            }
            .frame(maxWidth: .infinity)
            .frame(height: 100)
            .background(Color.grey6)
            .clipShape(RoundedRectangle(cornerRadius: 16))
        }
    }
    
    func menuTitleView(_ title: String) -> some View {
        Text(title)
            .pretendard(style: .title2)
            .foregroundStyle(Color.point1)
            .frame(maxWidth: .infinity, alignment: .leading)
            .padding(.horizontal, 16)
            .frame(height: 40)
    }
    
    var notificationToggleView: some View {
        HStack {
            VStack(spacing: 4) {
                Text("알림 수신 동의")
                    .pretendard(style: .body1)
                    .foregroundStyle(Color.white)
                    .frame(maxWidth: .infinity, alignment: .leading)
                
                Text("좋아요한 페스티벌 예매일, 행사일, 반입규정, 교통알림")
                    .pretendard(size: 10, weight: .regular)
                    .foregroundStyle(Color.grey4)
                    .frame(maxWidth: .infinity, alignment: .leading)
            }
            .layoutPriority(1)
            
            Toggle(
                "",
                isOn: Binding {
                    store.isNotificationOn
                } set: { isOn in
                    store.send(.toggleChanged(isOn))
                }
            )
            .tint(Color.point1)
            .renderedIf(!store.isLoading)
        }
        .frame(height: 64)
        .padding(.horizontal, 16)
    }
    
    func menuButton(
        _ menu: MyPageFeature.Menu,
        action: @escaping () -> Void
    ) -> some View {
        Button(action: action) {
            HStack(spacing: 0) {
                Text(title(of: menu))
                    .pretendard(style: .body1)
                    .foregroundStyle(Color.white)
                    .frame(maxWidth: .infinity, alignment: .leading)
                
                Image.iconChevronRight
                    .renderingMode(.template)
                    .resizable()
                    .frame(width: 24, height: 24)
                    .foregroundStyle(Color.white)
                    .padding(.vertical, 16)
            }
            .padding(.horizontal, 16)
        }
    }
    
    var divider: some View {
        Color.grey6
            .frame(maxWidth: .infinity)
            .frame(height: 1)
            .padding(.horizontal, 16)
    }
    
    var updateInfoSection: some View {
        HStack(spacing: 5) {
            Text("현재 버전")
                .pretendard(style: .body4)
                .foregroundStyle(Color.grey4)
            
            Text(store.currentVersion)
                .pretendard(style: .body4)
                .foregroundStyle(Color.grey3)
            
            Spacer()
            updateButton(store.isLatestVersion)
        }
        .padding(.horizontal, 16)
        .frame(height: 40)
    }
    
    func updateButton(_ isLatestVersion: Bool) -> some View {
        Button {
            
        } label: {
            let text = switch isLatestVersion {
            case true: "최신버전 사용중"
            case false: "업데이트 하러가기 >"
            }
            
            Text(text)
                .pretendard(style: .body4)
                .foregroundStyle(Color.grey3)
        }
        .disabled(isLatestVersion)
    }
}

extension MyPageFeature.AlertCase: AlertPresentable {
    public var alertInfo: AlertInfo {
        switch self {
        case .authorization: return .authorization
        case .error(.noInternet): return .noInternet
        case .error: return .error
        }
    }
}

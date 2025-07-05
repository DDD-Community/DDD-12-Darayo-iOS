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

public struct MyPageView: View {
    @Bindable private var store: StoreOf<MyPageFeature>
    
    public init(store: StoreOf<MyPageFeature>) {
        self.store = store
    }
    
    public var body: some View {
        VStack {
            navigationBar
            ScrollView {
                VStack(spacing: 0) {
                    versionInfoView
                    notificationSection
                    appInfoSection
                }
                .padding(.bottom, 24)
            }
        }
        .background(Color.background1)
    }
}

private extension MyPageView {
    func title(of menu: MyPageFeature.Menu) -> String {
        switch menu {
        case .favoritesNotification: "좋아요한 페스티벌 알림 받기"
        case .notificationSetting: "특정 페스티벌만 알림 받기"
        case .inquiry: "1:1 문의하기"
        case .termsOfService: "이용약관"
        case .privacyPolicy: "개인정보 처리방침"
        }
    }
}

private extension MyPageView {
    var navigationBar: some View {
        Text("MY")
            .pretendard(style: .title2)
            .foregroundStyle(Color.white)
            .frame(maxWidth: .infinity)
            .frame(height: 55)
    }
    
    var versionInfoView: some View {
        HStack(spacing: 0) {
            profileImageView
            versionText
            Spacer()
            updateInfoView
        }
        .padding(16)
    }
    
    var profileImageView: some View {
        Color.grey3
            .clipShape(Circle())
            .frame(width: 65, height: 65)
    }
    
    var versionText: some View {
        VStack(alignment: .leading, spacing: 2) {
            versionTextView(title: "현재 버전", version: store.currentVersion)
            versionTextView(title: "최신 버전", version: store.latestVersion)
        }
        .padding(.leading, 20)
    }
    
    func versionTextView(title: String, version: String) -> some View {
        HStack(spacing: 10) {
            Text(title)
                .pretendard(style: .body2)
                .foregroundStyle(Color.point1)
            
            Text(version)
                .pretendard(style: .body4)
                .foregroundStyle(Color.white)
        }
    }
    
    var updateInfoView: some View {
        Group {
            if store.isLatestVersion {
                Text("최신버전 사용중")
                    .pretendard(style: .caption2)
                    .foregroundStyle(Color.grey3)
            } else {
                Button {
                    
                } label: {
                    Text("업데이트 하러가기 >")
                        .pretendard(style: .caption2)
                        .foregroundStyle(Color.grey3)
                }
            }
        }
    }
    
    var notificationSection: some View {
        VStack(spacing: 0) {
            menuHeaderView(title: "알림")
            menuView(
                menu: .favoritesNotification,
                isOn: $store.isNotificationOn
            )
            divider
            menuButton(menu: .notificationSetting)
        }
    }
    
    var appInfoSection: some View {
        VStack(spacing: 0) {
            menuHeaderView(title: "앱 정보")
            menuButton(menu: .inquiry)
            divider
            menuButton(menu: .termsOfService)
            divider
            menuButton(menu: .privacyPolicy)
            divider
        }
    }
    
    var divider: some View {
        Color.grey4
            .frame(maxWidth: .infinity)
            .frame(height: 1)
    }
    
    func menuHeaderView(title: String) -> some View {
        Text(title)
            .pretendard(style: .title2)
            .foregroundStyle(Color.point1)
            .frame(maxWidth: .infinity, alignment: .leading)
            .padding(.horizontal, 16)
            .frame(height: 40)
            .background(Color.grey6)
    }
    
    func menuView(menu: MyPageFeature.Menu, isOn: Binding<Bool>) -> some View {
        HStack {
            Text(title(of: menu))
                .pretendard(style: .body1)
                .foregroundStyle(Color.white)
                .frame(maxWidth: .infinity, alignment: .leading)
                .layoutPriority(1)
            
            Toggle("", isOn: isOn)
                .tint(Color.point1)
        }
        .padding(16)
    }
    
    func menuButton(menu: MyPageFeature.Menu) -> some View {
        Button {
            store.send(.menuTapped(menu))
        } label: {
            HStack {
                Text(title(of: menu))
                    .pretendard(style: .body1)
                    .foregroundStyle(Color.white)
                
                Spacer()
                Image.iconChevronRight
                    .renderingMode(.template)
                    .resizable()
                    .frame(width: 24, height: 24)
                    .foregroundStyle(Color.white)
            }
            .padding(16)
        }
    }
}

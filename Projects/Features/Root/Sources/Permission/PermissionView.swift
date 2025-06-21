//
//  PermissionView.swift
//  Root
//
//  Created by 이정원 on 6/21/25.
//  Copyright © 2025 Darayo. All rights reserved.
//

import SwiftUI
import ComposableArchitecture
import DesignSystem

public struct PermissionView: View {
    private let store: StoreOf<PermissionFeature>
    
    public init(store: StoreOf<PermissionFeature>) {
        self.store = store
    }
    
    public var body: some View {
        VStack(spacing: 0) {
            titleView
            permissionView
            Spacer()
            infoTextView
        }
        .padding(.horizontal, 16)
        .padding(.bottom, 22)
        .background(Color.background1)
    }
}

private extension PermissionView {
    var titleView: some View {
        Text("앱 사용을 위해\n접근 권한을 허용해주세요")
            .pretendard(style: .title1)
            .multilineTextAlignment(.leading)
            .foregroundStyle(Color.white)
            .frame(maxWidth: .infinity, alignment: .leading)
            .padding(.vertical, 5)
            .padding(.top, 80)
    }
    
    var permissionView: some View {
        VStack(spacing: 24) {
            Text("선택 접근 권한")
                .pretendard(style: .title4)
                .foregroundStyle(Color.white)
                .frame(maxWidth: .infinity, alignment: .leading)
            
            VStack(spacing: 22) {
                permissionInfoView(
                    icon: Image.iconBell,
                    title: "알림",
                    message: "공연 및 예매 일자 등 페스티벌 관련 소식 알림"
                )
                
                permissionInfoView(
                    icon: Image.iconPicture,
                    title: "사진",
                    message: "타임테이블 이미지 저장"
                )
            }
        }
        .padding(.vertical, 24)
        .padding(.horizontal, 18)
        .background(Color.background2)
        .clipShape(RoundedRectangle(cornerRadius: 4))
        .padding(.top, 56)
    }
    
    func permissionInfoView(
        icon: Image,
        title: String,
        message: String
    ) -> some View {
        VStack(alignment: .leading, spacing: 8) {
            HStack(spacing: 5) {
                icon
                    .resizable()
                    .frame(width: 24, height: 24)
                
                Text(title)
                    .pretendard(style: .title2)
                    .foregroundStyle(Color.white)
            }
            
            Text(message)
                .pretendard(style: .body1)
                .foregroundStyle(Color.grey2)
                .frame(maxWidth: .infinity, alignment: .leading)
        }
    }
    
    var infoTextView: some View {
        VStack(spacing: 18) {
            Text("선택 접근 권한은 동의하지 않아도 앱의 기본 기능 이용이\n가능합니다.")
                .pretendard(style: .body4)
                .foregroundStyle(Color.white)
                .frame(maxWidth: .infinity, alignment: .leading)
            
            Text("접근 권한은 [휴대폰 설정 > 앱 > FESTIBEE]에서\n언제든 변경하실 수 있습니다.")
                .pretendard(style: .body4)
                .foregroundStyle(Color.white)
                .frame(maxWidth: .infinity, alignment: .leading)
        }
    }
}

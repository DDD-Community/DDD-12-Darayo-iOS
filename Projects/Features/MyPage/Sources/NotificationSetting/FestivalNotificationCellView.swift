//
//  FestivalNotificationCellView.swift
//  MyPage
//
//  Created by 이다영 on 7/6/25.
//  Copyright © 2025 Darayo. All rights reserved.
//

import SwiftUI
import ComposableArchitecture
import Domain
import DesignSystem

public struct FestivalNotificationCellView: View {
    public let festival: FestivalNotification
        public let toggleAction: () -> Void

        public init(
            festival: FestivalNotification,
            toggleAction: @escaping () -> Void
        ) {
            self.festival = festival
            self.toggleAction = toggleAction
        }
    public var body: some View {
        HStack(spacing: 0) {
            // 페스티벌 이미지
            festivalImageView
            
            // 페스티벌 정보
            VStack(alignment: .leading, spacing: 8) {
                Text(festival.name)
                    .pretendard(style: .title4)
                    .foregroundStyle(.white)
                    .lineLimit(1)
                
                VStack(alignment: .leading, spacing: 0) {
                    HStack(spacing: 6) {
                        Text("장소")
                            .pretendard(style: .body4)
                            .foregroundColor(.grey4)
                        
                        Text("어딘가")
                            .pretendard(style: .body4)
                            .foregroundColor(.grey3)
                            .lineLimit(1)
                    }
                    .frame(minHeight: 17, maxHeight: 17, alignment: .leading)
                
                    HStack(spacing: 6) {
                        Text("행사일")
                            .pretendard(style: .body4)
                            .foregroundColor(.grey4)
                        
                        Text("25.08.01 - 25.08.03")
                            .pretendard(style: .body4)
                            .foregroundColor(.grey3)
                    }
                    .frame(minHeight: 17, maxHeight: 17, alignment: .leading)
                }
            }
            .frame(maxWidth: .infinity, alignment: .leading)
            .padding(.leading, 12)
            
            Spacer()
            
            Button(action: toggleAction) {
                Image(systemName: festival.isNotificationOn ? "bell.fill" : "bell")
                    .font(.system(size: 24))
                    .foregroundStyle(.white)
            }
            .padding(.trailing, 12)
        }
        .background(Color.background2)
        .clipShape(RoundedRectangle(cornerRadius: 4))
    }
}

private extension FestivalNotificationCellView {
    var festivalImageView: some View {
        ZStack {
             Image.sampleFestival
                 .resizable()
                 .aspectRatio(contentMode: .fill)
                 .frame(width: 108, height: 88)
            
            // 그라데이션 오버레이
            LinearGradient(
                stops: [
                    .init(color: .black.opacity(0.6), location: 0.00),
                    .init(color: .black.opacity(0), location: 0.47),
                ],
                startPoint: UnitPoint(x: 0.5, y: 0),
                endPoint: UnitPoint(x: 0.5, y: 1)
            )
            .frame(width: 108, height: 88)
        }
        .clipShape(
            UnevenRoundedRectangle(
                topLeadingRadius: 4,
                bottomLeadingRadius: 4,
                bottomTrailingRadius: 0,
                topTrailingRadius: 0
            )
        )
    }
}

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

public struct FestivalNotificationCellView: View {
    public let festival: Festival
        public let toggleAction: () -> Void

        public init(
            festival: Festival,
            toggleAction: @escaping () -> Void
        ) {
            self.festival = festival
            self.toggleAction = toggleAction
        }
    public var body: some View {
        HStack {
            ZStack {
                Image.sampleFestival
                    .frame(width: 108, height: 80)
                    .clipShape(RoundedRectangle(cornerRadius: 6))
                
                LinearGradient(
                    stops: [
                        .init(color: .black, location: 0.00),
                        .init(color: .black.opacity(0), location: 0.47),
                    ],
                    startPoint: UnitPoint(x: 0.5, y: 0),
                    endPoint: UnitPoint(x: 0.5, y: 1)
                )
                .clipShape(RoundedRectangle(cornerRadius: 6))
            }
            
            VStack(alignment: .leading, spacing: 6) {
                Text(festival.title)
                    .pretendard(style: .title4)
                    .foregroundStyle(.white)
                    .lineLimit(1)
                
                VStack(alignment: .leading, spacing: 1) {
                    Text("장소")
                        .pretendard(style: .body4)
                        .foregroundColor(.grey4)
                    
                    Text(festival.place)
                        .pretendard(style: .body4)
                        .foregroundColor(.grey3)
                        .lineLimit(1)
                }
                
                VStack(alignment: .leading, spacing: 1) {
                    Text("행사일")
                        .pretendard(style: .body4)
                        .foregroundColor(.grey4)
                    
                    Text(festival.dateString)
                        .pretendard(style: .body4)
                        .foregroundColor(.grey3)
                }
            }
            Spacer()
        }
    }
}

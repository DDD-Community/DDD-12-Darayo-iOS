//
//  FestivalListView.swift
//  MyPage
//
//  Created by 이정원 on 7/24/25.
//  Copyright © 2025 Darayo. All rights reserved.
//

import SwiftUI
import ComposableArchitecture
import DesignSystem
import Domain

struct FestivalListView: View {
    private let festivals: [Festival]
    private let isLoading: Bool
    private let action: (Festival) -> Void
    private let deleteAction: (Festival) -> Void
    
    init(
        festivals: [Festival],
        isLoading: Bool,
        action: @escaping (Festival) -> Void,
        deleteAction: @escaping (Festival) -> Void
    ) {
        self.festivals = festivals
        self.isLoading = isLoading
        self.action = action
        self.deleteAction = deleteAction
    }
    
    var body: some View {
        Group {
            switch isLoading {
            case true: shimmerListView
            case false:
                switch festivals.isEmpty {
                case true: emptyView
                case false: festivalListView
                }
            }
        }
        .animation(.easeInOut(duration: 0.2), value: festivals.isEmpty)
    }
}

private extension FestivalListView {
    var shimmerListView: some View {
        ScrollView([]) {
            VStack(spacing: 12) {
                ForEach(0..<20, id: \.self) { _ in
                    ShimmerView()
                        .frame(maxWidth: .infinity)
                        .frame(height: 88)
                        .clipShape(RoundedRectangle(cornerRadius: 4))
                }
            }
            .padding(16)
        }
    }
    
    var emptyView: some View {
        VStack(spacing: 22) {
            Image.star
            Text("알림 설정한 페스티벌이 없어요!")
                .pretendard(style: .title2)
                .foregroundStyle(Color.white)
        }
        .frame(maxHeight: .infinity)
    }
    
    var festivalListView: some View {
        ScrollView {
            VStack(spacing: 12) {
                ForEach(0..<festivals.count, id: \.self) { index in
                    let festival = festivals[index]
                    festivalView(festival: festival) {
                        action(festival)
                    } notificationAction: {
                        deleteAction(festival)
                    }
                }
            }
            .padding(16)
        }
        .animation(.easeInOut, value: festivals)
    }
    
    func festivalView(
        festival: Festival,
        action: @escaping () -> Void,
        notificationAction: @escaping () -> Void
    ) -> some View {
        Button(action: action) {
            HStack(spacing: 0) {
                imageView(url: festival.posterURL)
                
                HStack(spacing: 8) {
                    VStack(spacing: 8) {
                        Text(festival.name)
                            .pretendard(style: .title4)
                            .foregroundStyle(Color.white)
                            .lineLimit(1)
                            .frame(maxWidth: .infinity, alignment: .leading)
                        
                        VStack(spacing: 0) {
                            textInfoView(title: "장소", contents: festival.placeName)
                            textInfoView(title: "행사일", contents: festival.dateString)
                        }
                    }
                    
                    Button(action: notificationAction) {
                        Image.iconNotificationFill
                            .resizable()
                            .frame(width: 24, height: 24)
                    }
                }
                .padding(12)
                .frame(height: 88)
                .background(Color.background2)
            }
            .clipShape(RoundedRectangle(cornerRadius: 4))
        }
    }
    
    func imageView(url: URL?) -> some View {
        ZStack {
            ImageView(url, placeholder: .placeholder3)
                .scaledToFill()
                .frame(width: 108, height: 88)
                .clipped()
            
            LinearGradient(
                gradient: .init(
                    colors: [
                        .black.opacity(0.5),
                        .black.opacity(0)
                    ]
                ),
                startPoint: .top,
                endPoint: .bottom
            )
            .frame(width: 108, height: 88)
        }
    }
    
    func textInfoView(title: String, contents: String) -> some View {
        HStack(spacing: 6) {
            Text(title)
                .pretendard(style: .body4)
                .foregroundStyle(Color.grey4)
            
            Text(contents)
                .pretendard(style: .body4)
                .foregroundStyle(Color.grey3)
                .frame(maxWidth: .infinity, alignment: .leading)
                .lineLimit(1)
        }
    }
}

//
//  SubscribedFestivalListView.swift
//  MyPage
//
//  Created by 이정원 on 7/24/25.
//  Copyright © 2025 Darayo. All rights reserved.
//

import SwiftUI
import ComposableArchitecture
import DesignSystem
import Domain

struct SubscribedFestivalListView: View {
    private let festivals: [Festival]
    private let action: (Festival) -> Void
    
    init(
        festivals: [Festival],
        action: @escaping (Festival) -> Void
    ) {
        self.festivals = festivals
        self.action = action
    }
    
    var body: some View {
        VStack(spacing: 12) {
            ForEach(0..<festivals.count, id: \.self) { index in
                let festival = festivals[index]
                festivalView(festival: festival) {
                    action(festival)
                }
            }
        }
    }
}

private extension SubscribedFestivalListView {
    func festivalView(
        festival: Festival,
        action: @escaping () -> Void
    ) -> some View {
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
                
                Button(action: action) {
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
    
    func imageView(url: URL?) -> some View {
        ZStack {
            if let url {
                AsyncImage(url: url) { phase in
                    if let image = phase.image {
                        image
                            .resizable()
                            .aspectRatio(contentMode: .fill)
                    } else {
                        Color.grey3
                    }
                }
                .frame(width: 108, height: 88)
                .clipped()
            }
            
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

//
//  FestivalGridView.swift
//  Home
//
//  Created by 이정원 on 6/24/25.
//  Copyright © 2025 Darayo. All rights reserved.
//

import SwiftUI
import DesignSystem
import Domain

struct FestivalGridView: View {
    private let festivals: [Festival]
    private let isFavorite: [Bool]
    private let isLoading: Bool
    private let festivalTapped: (Festival) -> Void
    private let heartButtonTapped: (Festival) -> Void
    
    init(
        festivals: [Festival],
        isFavorite: [Bool],
        isLoading: Bool,
        festivalTapped: @escaping (Festival) -> Void,
        heartButtonTapped: @escaping (Festival) -> Void
    ) {
        self.festivals = festivals
        self.isFavorite = isFavorite
        self.isLoading = isLoading
        self.festivalTapped = festivalTapped
        self.heartButtonTapped = heartButtonTapped
    }
    
    private let columns = [
        GridItem(.flexible(), spacing: 13),
        GridItem(.flexible(), spacing: 13)
    ]
    
    var body: some View {
        switch isLoading {
        case true: shimmerGridView
        case false: gridView
        }
    }
}

private extension FestivalGridView {
    var gridView: some View {
        LazyVGrid(columns: columns, spacing: 16) {
            ForEach(0..<festivals.count, id: \.self) { index in
                ZStack(alignment: .topLeading) {
                    festivalCardView(festival: festivals[index])
                    heartButton(isFavorite: isFavorite[index]) {
                        heartButtonTapped(festivals[index])
                    }
                }
            }
        }
    }
    
    var shimmerGridView: some View {
        LazyVGrid(columns: columns, spacing: 16) {
            ForEach(0..<12, id: \.self) { index in
                ShimmerView()
                    .frame(maxWidth: .infinity)
                    .frame(height: 224)
                    .clipShape(RoundedRectangle(cornerRadius: 4))
            }
        }
    }
    
    func festivalCardView(festival: Festival) -> some View {
        Button {
            festivalTapped(festival)
        } label: {
            VStack(spacing: 0) {
                imageView(url: festival.posterURL)
                
                VStack(spacing: 0) {
                    Text(festival.dateString)
                        .pretendard(style: .body3)
                        .foregroundStyle(Color.point2)
                        .frame(maxWidth: .infinity, alignment: .leading)
                    
                    Text(festival.name)
                        .pretendard(style: .title3)
                        .foregroundStyle(Color.white)
                        .multilineTextAlignment(.leading)
                        .frame(maxWidth: .infinity, alignment: .leading)
                        .frame(height: 42, alignment: .top)
                        .lineLimit(2)
                        .padding(.top, 4)
                    
                    Text(festival.placeName)
                        .pretendard(style: .body4)
                        .foregroundStyle(Color.grey3)
                        .frame(maxWidth: .infinity, alignment: .leading)
                        .lineLimit(1)
                        .padding(.top, 6)
                }
                .padding(.horizontal, 12)
                .padding(.top, 12)
                .padding(.bottom, 14)
                .background(Color.background2)
            }
        }
        .clipShape(RoundedRectangle(cornerRadius: 4))
        .buttonStyle(.plain)
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
                .frame(height: 110)
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
        }
    }
    
    func heartButton(
        isFavorite: Bool,
        action: @escaping () -> Void
    ) -> some View {
        let heart: Image = switch isFavorite {
        case true: Image.iconHeartFill
        case false: Image.iconHeart
        }
        
        return Button(action: action) {
            heart
                .resizable()
                .frame(width: 28, height: 28)
        }
        .padding(.leading, 12)
        .padding(.top, 12)
    }
}

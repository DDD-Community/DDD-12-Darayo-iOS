//
//  ArtistInfoView.swift
//  Home
//
//  Created by 이정원 on 7/1/25.
//  Copyright © 2025 Darayo. All rights reserved.
//

import SwiftUI
import DesignSystem
import Domain
import Kingfisher

struct ArtistInfoView: View {
    private let artists: [Artist]
    private let action: () -> Void
    
    init(
        artists: [Artist],
        action: @escaping () -> Void
    ) {
        self.artists = artists
        self.action = action
    }
    
    var body: some View {
        Group {
            switch artists.isEmpty {
            case true:
                EmptyInfoView(title: "아티스트")
            case false:
                VStack(spacing: 16) {
                    HStack {
                        titleView
                        Spacer()
                        seeAllButton
                    }
                    .padding(.horizontal, 16)
                    
                    artistListView
                }
                .padding(.top, 12)
                .padding(.bottom, 16)
                .background(Color.background2)
                .clipShape(RoundedRectangle(cornerRadius: 8))
            }
        }
    }
}

private extension ArtistInfoView {
    var titleView: some View {
        Text("아티스트")
            .pretendard(style: .body3)
            .foregroundStyle(Color.point1)
    }
    
    var seeAllButton: some View {
        Button(action: action) {
            Text("전체보기 >")
                .pretendard(style: .caption1)
                .foregroundStyle(Color.grey3)
        }
    }
    
    var artistListView: some View {
        ScrollView(.horizontal) {
            LazyHStack(spacing: 10) {
                ForEach(0..<min(10, artists.count), id: \.self) { index in
                    artistView(artist: artists[index])
                }
            }
            .padding(.horizontal, 16)
        }
        .scrollIndicators(.hidden)
    }
    
    func artistView(artist: Artist) -> some View {
        VStack(spacing: 6) {
            KFImage(artist.imageURL(100))
                .placeholder {
                    Image.iconArtistPlaceholder
                        .resizable()
                        .frame(width: 56, height: 56)
                }
                .resizable()
                .frame(width: 56, height: 56)
                .clipShape(RoundedRectangle(cornerRadius: 28))
            
            Text(artist.name)
                .pretendard(style: .body3)
                .foregroundStyle(Color.grey1)
                .lineLimit(1)
        }
        .frame(width: 65)
    }
}

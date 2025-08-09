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
        VStack(spacing: artists.isEmpty ? 0 : 12) {
            HStack {
                titleView
                Spacer()
                seeAllButton
            }
            .padding(.horizontal, 16)
            
            switch artists.isEmpty {
            case true: emptyView
            case false: artistListView
            }
            
        }
        .padding(.top, 12)
        .padding(.bottom, artists.isEmpty ? 12 : 16)
        .background(Color.background2)
        .clipShape(RoundedRectangle(cornerRadius: 8))
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
        .renderedIf(!artists.isEmpty)
    }
    
    var emptyView: some View {
        VStack(spacing: 4) {
            Image.star
                .renderingMode(.template)
                .resizable()
                .frame(width: 25, height: 25)
                .foregroundStyle(Color.grey5)
            
            Text("아직 등록된 정보가 없어요")
                .pretendard(style: .body5)
                .foregroundStyle(Color.grey4)
                .frame(maxWidth: .infinity)
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
            Image.iconArtistPlaceholder
                .resizable()
                .frame(width: 56, height: 56)
            
            Text(artist.name)
                .pretendard(style: .body3)
                .foregroundStyle(Color.grey1)
                .lineLimit(1)
        }
        .frame(width: 65)
    }
}

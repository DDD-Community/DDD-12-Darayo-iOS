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
        VStack(spacing: 12) {
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
        .padding(.bottom, 20)
        .background(Color.grey6)
        .clipShape(RoundedRectangle(cornerRadius: 10))
    }
}

private extension ArtistInfoView {
    var titleView: some View {
        Text("아티스트")
            .pretendard(style: .title3)
            .foregroundStyle(Color.white)
    }
    
    var seeAllButton: some View {
        Button(action: action) {
            Text("전체보기 >")
                .pretendard(style: .caption2)
                .foregroundStyle(Color.white)
        }
        .renderedIf(!artists.isEmpty)
    }
    
    var emptyView: some View {
        Text("아직 등록된 아티스트가 없어요")
            .pretendard(style: .body0)
            .foregroundStyle(Color.white)
            .frame(maxWidth: .infinity)
    }
    
    var artistListView: some View {
        ScrollView(.horizontal) {
            LazyHStack(spacing: 10) {
                ForEach(0..<artists.count, id: \.self) { index in
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
                .foregroundStyle(Color.white)
        }
        .frame(minWidth: 65)
    }
}

//
//  ArtistGridListView.swift
//  Home
//
//  Created by 이정원 on 7/3/25.
//  Copyright © 2025 Darayo. All rights reserved.
//

import SwiftUI
import DesignSystem
import Domain

struct ArtistGridListView: View {
    private let artists: [[Artist]]
    private let selectedIndex: Int
    
    init(
        artists: [[Artist]],
        selectedIndex: Int
    ) {
        self.artists = artists
        self.selectedIndex = selectedIndex
    }
    
    private let columns = [
        GridItem(.flexible(), spacing: 20),
        GridItem(.flexible(), spacing: 20),
        GridItem(.flexible(), spacing: 20)
    ]
    
    var body: some View {
        ScrollViewReader { proxy in
            ScrollView {
                LazyVStack(spacing: 0) {
                    ForEach(0..<artists.count, id: \.self) { index in
                        VStack(spacing: 0) {
                            Text("DAY\(index + 1)")
                                .pretendard(style: .title1)
                                .foregroundStyle(Color.point1)
                                .frame(maxWidth: .infinity)
                                .id(index)
                            
                            artistGridView(artists[index])
                        }
                    }
                }
                .padding(.horizontal, 16)
            }
            .onChange(of: selectedIndex) { _, index in
                withAnimation {
                    proxy.scrollTo(index, anchor: .top)
                }
            }
        }
    }
}

private extension ArtistGridListView {
    func artistGridView(_ artists: [Artist]) -> some View {
        LazyVGrid(columns: columns, spacing: 16) {
            ForEach(0..<artists.count, id: \.self) { index in
                artistView(artists[index])
            }
        }
        .padding(.vertical, 16)
    }
    
    func artistView(_ artist: Artist) -> some View {
        VStack(spacing: 6) {
            Image.iconArtistPlaceholder
                .resizable()
                .frame(maxWidth: .infinity)
                .aspectRatio(1.0, contentMode: .fit)
            
            Text(artist.name)
                .pretendard(style: .body3)
                .foregroundStyle(Color.white)
                .frame(maxWidth: .infinity)
                .multilineTextAlignment(.center)
        }
    }
}

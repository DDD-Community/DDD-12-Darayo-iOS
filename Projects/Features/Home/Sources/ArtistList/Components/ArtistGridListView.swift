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
    private let indexToScroll: (Int, Date)?
    private let onIndexChange: (Int) -> Void
    
    @State private var bottomPadding: CGFloat = 0
    
    init(
        artists: [[Artist]],
        indexToScroll: (Int, Date)?,
        onIndexChange: @escaping (Int) -> Void
    ) {
        self.artists = artists
        self.indexToScroll = indexToScroll
        self.onIndexChange = onIndexChange
    }

    private let columns: [GridItem] = .init(
        repeating: .init(.flexible(), spacing: 20, alignment: .top),
        count: 3
    )
    
    var body: some View {
        GeometryReader { geometryProxy in
            ScrollViewReader { scrollProxy in
                ScrollView {
                    artistGridListView()
                }
                .onPreferenceChange(AnchorsKey.self) { anchors in
                    updateIndex(geometryProxy, anchors)
                    updateBottomPadding(geometryProxy, anchors)
                }
                .onChange(of: indexToScroll?.1) { _, _ in
                    guard let index = indexToScroll?.0 else { return }
                    withAnimation {
                        scrollProxy.scrollTo(index, anchor: .top)
                    }
                }
            }
        }
        .overlay(alignment: .bottom) { gradient }
        .ignoresSafeArea()
    }
}

private extension ArtistGridListView {
    func artistGridListView() -> some View {
        VStack(spacing: 0) {
            ForEach(0..<artists.count, id: \.self) { index in
                VStack(spacing: 0) {
                    textHeaderView(index)
                    artistGridView(artists[index])
                }
                .anchorPreference(key: AnchorsKey.self, value: .bounds) { anchor in
                    [index: anchor]
                }
            }
        }
        .padding(.horizontal, 16)
        .padding(.bottom, bottomPadding)
    }
    
    func textHeaderView(_ index: Int) -> some View {
        Text("DAY\(index + 1)")
            .pretendard(style: .title1)
            .foregroundStyle(Color.point1)
            .frame(maxWidth: .infinity)
            .id(index)
    }
    
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
    
    var gradient: some View {
        LinearGradient(
            stops: [
                Gradient.Stop(color: Color.background1.opacity(0), location: 0.00),
                Gradient.Stop(color: Color.background1, location: 1.00)
            ],
            startPoint: .top,
            endPoint: .bottom
        )
        .frame(height: 184)
        .allowsHitTesting(false)
    }
}

private extension ArtistGridListView {
    func updateIndex(_ proxy: GeometryProxy, _ anchors: [Int: Anchor<CGRect>]) {
        let index = anchors
            .filter{ proxy[$0.value].maxY > 0 }
            .sorted { proxy[$0.value].maxY < proxy[$1.value].maxY }
            .first?.key
        
        guard let index else { return }
        onIndexChange(index)
    }
    
    func updateBottomPadding(_ proxy: GeometryProxy, _ anchors: [Int: Anchor<CGRect>]) {
        guard let lastAnchor = anchors[artists.count - 1] else { return }
        let lastItemHeight = proxy[lastAnchor].height
        let scrollViewHeight = proxy.size.height
        let extraPadding = max(184, scrollViewHeight - lastItemHeight)
        bottomPadding = extraPadding
    }
}

private struct AnchorsKey: PreferenceKey {
    static var defaultValue: [Int: Anchor<CGRect>] = [:]
    
    static func reduce(
        value: inout [Int: Anchor<CGRect>],
        nextValue: () -> [Int: Anchor<CGRect>]
    ) {
        value.merge(nextValue()) { $1 }
    }
}

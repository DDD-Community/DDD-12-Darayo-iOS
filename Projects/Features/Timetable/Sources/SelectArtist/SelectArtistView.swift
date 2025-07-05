//
//  SelectArtistView.swift
//  Timetable
//
//  Created by 이정원 on 7/4/25.
//  Copyright © 2025 Darayo. All rights reserved.
//

import SwiftUI
import ComposableArchitecture
import DesignSystem
import Domain

public struct SelectArtistView: View {
    private let store: StoreOf<SelectArtistFeature>
    
    private let columns: [GridItem] = .init(
        repeating: .init(.flexible(), spacing: 20),
        count: 4
    )
    
    public init(store: StoreOf<SelectArtistFeature>) {
        self.store = store
    }
    
    public var body: some View {
        VStack(spacing: 0) {
            navigationBar
            ScrollView {
                artistGridView
            }
            doneButton
        }
        .padding(.horizontal, 16)
        .padding(.top, 24)
        .padding(.bottom, 16)
        .background(Color.background2)
    }
}

private extension SelectArtistView {
    var navigationBar: some View {
        ZStack(alignment: .trailing) {
            Text("아티스트 선택")
                .pretendard(style: .title1)
                .frame(maxWidth: .infinity)
            
            Button {
                store.send(.closeButtonTapped)
            } label: {
                Image.iconClose
                    .resizable()
                    .frame(width: 24, height: 24)
            }
        }
        .padding(.bottom, 20)
    }
    
    var artistGridView: some View {
        LazyVGrid(columns: columns, spacing: 10) {
            ForEach(0..<store.artists.count, id: \.self) { index in
                artistView(store.artists[index])
            }
        }
        .padding(.horizontal, 11.5)
        .padding(.bottom, 14)
    }
    
    func artistView(_ artist: Artist) -> some View {
        Button {
            store.send(.artistButtonTapped(artist))
        } label: {
            VStack(spacing: 6) {
                let isSelected = store.selectedArtists.contains(artist)
                let image: Image = switch isSelected {
                case true: .iconArtistPlaceholderSelected
                case false: .iconArtistPlaceholder
                }
                
                image
                    .resizable()
                    .frame(maxWidth: .infinity)
                    .aspectRatio(1.0, contentMode: .fit)
                    .padding(.horizontal, 4.5)
                
                Text(artist.name)
                    .pretendard(style: .body3)
                    .frame(maxWidth: .infinity)
                    .foregroundStyle(isSelected ? Color.point1 : Color.white)
            }
        }
    }
    
    var doneButton: some View {
        Button("적용하기") {
            store.send(.doneButtonTapped)
        }
        .buttonStyle(.festibee)
        .padding(.top, 16)
    }
}

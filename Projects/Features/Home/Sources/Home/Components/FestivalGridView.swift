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
    private let action: (Festival) -> Void
    @State private var isFavorite: [Bool]
    
    init(
        festivals: [Festival],
        action: @escaping (Festival) -> Void
    ) {
        self.isFavorite = .init(repeating: false, count: festivals.count)
        self.festivals = festivals
        self.action = action
    }
    
    private let columns = [
        GridItem(.flexible(), spacing: 13),
        GridItem(.flexible(), spacing: 13)
    ]
    
    var body: some View {
        ScrollView {
            LazyVGrid(columns: columns, spacing: 16) {
                ForEach(0..<festivals.count, id: \.self) { index in
                    ZStack(alignment: .topLeading) {
                        festivalCardView(festival: festivals[index])
                        heartView(isFavorite: $isFavorite[index])
                    }
                }
            }
        }
    }
}

private extension FestivalGridView {
    func festivalCardView(festival: Festival) -> some View {
        Button {
            action(festival)
        } label: {
            VStack(spacing: 0) {
                imageView(image: Image.sampleFestival)
                
                VStack(spacing: 0) {
                    Text(festival.dateString)
                        .pretendard(style: .body3)
                        .foregroundStyle(Color.point2)
                        .frame(maxWidth: .infinity, alignment: .leading)
                    
                    Text(festival.title)
                        .pretendard(style: .title3)
                        .foregroundStyle(Color.white)
                        .multilineTextAlignment(.leading)
                        .frame(maxWidth: .infinity, alignment: .leading)
                        .frame(height: 42, alignment: .top)
                        .lineLimit(2)
                        .padding(.top, 4)
                    
                    Text(festival.place)
                        .pretendard(style: .body4)
                        .foregroundStyle(Color.grey4)
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
    
    func imageView(image: Image) -> some View {
        ZStack {
            image
                .resizable()
                .aspectRatio(contentMode: .fill)
                .frame(height: 110)
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
        }
    }
    
    func heartView(isFavorite: Binding<Bool>) -> some View {
        let heart: Image = switch isFavorite.wrappedValue {
        case true: Image.iconHeartFill
        case false: Image.iconHeart
        }
        
        return Button {
            isFavorite.wrappedValue.toggle()
        } label: {
            heart
                .resizable()
                .frame(width: 28, height: 28)
        }
        .padding(.leading, 12)
        .padding(.top, 12)
    }
}

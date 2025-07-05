//
//  FestivalInfoView.swift
//  Home
//
//  Created by 이정원 on 6/30/25.
//  Copyright © 2025 Darayo. All rights reserved.
//

import SwiftUI
import DesignSystem

struct FestivalInfoView: View {
    private let title: String
    private let place: String
    private let dateString: String
    
    init(
        title: String,
        place: String,
        dateString: String
    ) {
        self.title = title
        self.place = place
        self.dateString = dateString
    }
    
    var body: some View {
        ZStack {
            imageView
            gradient
            
            VStack(spacing: 9) {
                Spacer()
                titleView
                VStack(spacing: 4) {
                    itemInfoView(title: "행사장소", contents: place)
                    itemInfoView(title: "행사일자", contents: dateString)
                }
            }
            .padding(.horizontal, 20)
            .padding(.vertical, 16)
        }
        .clipShape(RoundedRectangle(cornerRadius: 10))
    }
}

private extension FestivalInfoView {
    var imageView: some View {
        Image.sampleFestival
            .resizable()
            .scaledToFill()
            .frame(maxWidth: .infinity)
            .frame(height: 190)
            .clipped()
    }
    
    var gradient: some View {
        LinearGradient(
            stops: [
                .init(color: .point2.opacity(0.0), location: 0.0),
                .init(color: .point2, location: 1.0)
            ],
            startPoint: .init(x: 0.5, y: -0.04),
            endPoint: .init(x: 0.5, y: 0.67)
        )
    }
    
    var titleView: some View {
        Text(title)
            .pretendard(style: .title1)
            .multilineTextAlignment(.leading)
            .frame(maxWidth: .infinity, alignment: .leading)
    }
    
    func itemInfoView(title: String , contents: String) -> some View {
        HStack(alignment: .top, spacing: 18) {
            Text(title)
                .pretendard(style: .caption1)
                .foregroundStyle(Color.point1)
            
            Text(contents)
                .pretendard(style: .caption2)
                .foregroundStyle(Color.white)
                .frame(maxWidth: .infinity, alignment: .leading)
                .multilineTextAlignment(.leading)
        }
    }
}

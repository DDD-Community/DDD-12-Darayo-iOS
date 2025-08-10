//
//  FestivalInfoView.swift
//  Home
//
//  Created by 이정원 on 8/9/25.
//  Copyright © 2025 Darayo. All rights reserved.
//

import SwiftUI
import DesignSystem
import Domain

struct FestivalInfoView: View {
    private let title: String
    private let place: String
    private let dateString: String
    private let urlInfos: [URLInfo]
    @Environment(\.openURL) private var openURL
    
    init(
        title: String,
        place: String,
        dateString: String,
        urlInfos: [URLInfo]
    ) {
        self.title = title
        self.place = place
        self.dateString = dateString
        self.urlInfos = urlInfos
    }
    
    var body: some View {
        VStack(spacing: 12) {
            HStack(alignment: .top, spacing: 16) {
                titleView
                buttonSection
            }
            infoView
        }
    }
}

private extension FestivalInfoView {
    var titleView: some View {
        Text(title)
            .pretendard(style: .title1)
            .foregroundStyle(Color.white)
            .frame(maxWidth: .infinity, alignment: .leading)
    }
    
    var buttonSection: some View {
        let instagram = urlInfos.first { $0.platform == .instagram }
        let homepage = urlInfos.first { $0.platform == .homepage }
        
        return HStack(spacing: 4) {
            if let instagram { linkButton(instagram) }
            if let homepage { linkButton(homepage) }
        }
    }
    
    func linkButton(_ urlInfo: URLInfo) -> some View {
        let image: Image = switch urlInfo.platform {
        case .homepage: .iconWebsite
        case .instagram: .iconInstagram
        }
        
        return Button {
            let url = URL(string: urlInfo.urlString)
            guard let url else { return }
            openURL(url)
        } label: {
            ZStack {
                Color.white.opacity(0.1)
                
                image
                    .renderingMode(.template)
                    .resizable()
                    .frame(width: 16, height: 16)
                    .foregroundStyle(Color.grey2)
            }
            .frame(width: 28, height: 28)
            .clipShape(RoundedRectangle(cornerRadius: 8))
        }
    }
    
    var infoView: some View {
        VStack(spacing: 4) {
            infoView(title: "행사장소", contents: place)
            infoView(title: "행사일자", contents: dateString)
        }
    }
    
    func infoView(title: String, contents: String) -> some View {
        HStack(alignment: .top, spacing: 18) {
            Text(title)
                .pretendard(style: .body3)
                .foregroundStyle(Color.point1)
            
            Text(contents)
                .pretendard(style: .body3)
                .foregroundStyle(Color.white)
                .frame(maxWidth: .infinity, alignment: .leading)
        }
    }
}

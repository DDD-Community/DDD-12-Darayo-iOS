//
//  TicketInfoView.swift
//  Home
//
//  Created by 이정원 on 6/30/25.
//  Copyright © 2025 Darayo. All rights reserved.
//

import SwiftUI
import DesignSystem
import Domain

struct TicketInfoView: View {
    private let vendors: [Vendor]
    private let purchaseDates: [String]
    private let platforms: [Platform]
    
    init(
        vendors: [Vendor],
        purchaseDates: [String],
        platforms: [Platform]
    ) {
        self.vendors = vendors
        self.purchaseDates = purchaseDates
        self.platforms = platforms
    }
    
    var body: some View {
        VStack(alignment: .leading, spacing: 12) {
            titleView
            vendorInfoView
            dateInfoView
            platformInfoView
        }
        .padding(.horizontal, 16)
        .padding(.top, 12)
        .padding(.bottom, 20)
        .background(Color.grey6)
        .clipShape(RoundedRectangle(cornerRadius: 10))
    }
}

private extension TicketInfoView {
    var titleView: some View {
        Text("예매정보")
            .pretendard(style: .title3)
            .foregroundStyle(Color.white)
            .frame(maxWidth: .infinity, alignment: .leading)
    }
    
    var vendorInfoView: some View {
        HStack(alignment: .top, spacing: 12) {
            Text("예매처")
                .pretendard(style: .body2)
                .foregroundStyle(Color.point1)
                .frame(width: 50, alignment: .leading)
            
            vendorListView
        }
    }
    
    var vendorListView: some View {
        WrappingHStack(
            horizontalSpacing: 12,
            verticalSpacing: 5
        ) {
            ForEach(0..<vendors.count, id: \.self) { index in
                let vendor = vendors[index]
                
                Button {
                    
                } label: {
                    HStack(spacing: 6) {
                        Text("\(vendor.name) 티켓")
                            .pretendard(style: .body0)
                            .foregroundStyle(Color.white)
                        
                        Image.iconLink
                            .renderingMode(.template)
                            .resizable()
                            .frame(width: 12, height: 12)
                            .foregroundStyle(Color.white)
                    }
                }
            }
        }
    }
    
    var dateInfoView: some View {
        HStack(alignment: .top, spacing: 12) {
            Text("예매일자")
                .pretendard(style: .body2)
                .foregroundStyle(Color.point1)
                .frame(width: 50, alignment: .leading)
            
            VStack(spacing: 2) {
                ForEach(0..<purchaseDates.count, id: \.self) { index in
                    Text(purchaseDates[index])
                        .pretendard(style: .body0)
                        .foregroundStyle(Color.white)
                        .frame(maxWidth: .infinity, alignment: .leading)
                }
            }
        }
    }
    
    var platformInfoView: some View {
        HStack(spacing: 12) {
            Text("공식계정")
                .pretendard(style: .body2)
                .foregroundStyle(Color.point1)
                .frame(width: 50, alignment: .leading)
            
            HStack(spacing: 9) {
                ForEach(0..<platforms.count, id: \.self) { index in
                    let image: Image = switch platforms[index] {
                    case .instagram: .iconInstagram
                    case .website: .iconWebsite
                    }
                    
                    Button {
                        
                    } label: {
                        image
                            .renderingMode(.template)
                            .resizable()
                            .frame(width: 20, height: 20)
                            .foregroundStyle(Color.white)
                    }
                }
                Spacer()
            }
        }
    }
}

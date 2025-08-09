//
//  NewTicketInfoView.swift
//  Home
//
//  Created by 이정원 on 8/9/25.
//  Copyright © 2025 Darayo. All rights reserved.
//

import SwiftUI
import DesignSystem
import Domain

struct NewTicketInfoView: View {
    private let vendors: [Vendor]
    private let purchaseDates: [String]
    @Environment(\.openURL) private var openURL
    
    init(
        vendors: [Vendor],
        purchaseDates: [String]
    ) {
        self.vendors = vendors
        self.purchaseDates = purchaseDates
    }
    
    var body: some View {
        VStack(spacing: 12) {
            vendorSection
            purchaseDateSection
        }
        .padding(16)
        .background(Color.background2)
        .clipShape(RoundedRectangle(cornerRadius: 8))
    }
}

private extension NewTicketInfoView {
    var vendorSection: some View {
        HStack(
            alignment: vendors.isEmpty ? .center : .top,
            spacing: 12
        ) {
            Text("예매처")
                .pretendard(style: .body3)
                .foregroundStyle(Color.point1)
                .frame(width: 50, alignment: .leading)
                .padding(.top, vendors.isEmpty ? 0 : 5)
            
            WrappingHStack(horizontalSpacing: 8, verticalSpacing: 8) {
                ForEach(0..<vendors.count, id: \.self) { index in
                    vendorButton(vendors[index])
                }
            }
            .renderedIf(!vendors.isEmpty)
            
            Text("미정")
                .pretendard(style: .body5)
                .foregroundStyle(Color.grey4)
                .frame(maxWidth: .infinity, alignment: .leading)
                .renderedIf(vendors.isEmpty)
        }
    }
    
    func vendorButton(_ vendor: Vendor) -> some View {
        Button {
            let url = URL(string: vendor.urlString)
            guard let url else { return }
            openURL(url)
        } label: {
            HStack(spacing: 8) {
                Text(vendor.name)
                    .pretendard(style: .caption1)
                    .foregroundStyle(Color.white)
                
                Image.iconLink
                    .renderingMode(.template)
                    .resizable()
                    .frame(width: 8, height: 8)
                    .foregroundStyle(Color.white)
            }
            .padding(.horizontal, 12)
            .padding(.vertical, 6)
            .background(Color.grey5)
            .clipShape(RoundedRectangle(cornerRadius: 10))
        }
    }
    
    var purchaseDateSection: some View {
        HStack(
            alignment: vendors.isEmpty ? .center : .top,
            spacing: 12
        ) {
            Text("예매일자")
                .pretendard(style: .body3)
                .foregroundStyle(Color.point1)
                .frame(width: 50, alignment: .leading)
            
            VStack(spacing: 2) {
                ForEach(0..<purchaseDates.count, id: \.self) { index in
                    Text(purchaseDates[index])
                        .pretendard(style: .body4)
                        .foregroundStyle(Color.grey1)
                        .frame(maxWidth: .infinity, alignment: .leading)
                }
            }
            .renderedIf(!purchaseDates.isEmpty)
            
            Text("미정")
                .pretendard(style: .body5)
                .foregroundStyle(Color.grey4)
                .frame(maxWidth: .infinity, alignment: .leading)
                .renderedIf(purchaseDates.isEmpty)
        }
    }
}

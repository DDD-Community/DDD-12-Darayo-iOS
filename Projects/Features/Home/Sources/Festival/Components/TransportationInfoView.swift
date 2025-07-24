//
//  TransportationInfoView.swift
//  Home
//
//  Created by 이정원 on 7/1/25.
//  Copyright © 2025 Darayo. All rights reserved.
//

import SwiftUI
import DesignSystem
import Domain

struct TransportationInfoView: View {
    private let transportationInfo: String
    
    init(transportationInfo: String) {
        self.transportationInfo = transportationInfo
    }
    
    var body: some View {
        VStack(spacing: 12) {
            titleView
            
            emptyView
                .renderedIf(transportationInfo.isEmpty)
            
            VStack(spacing: 12) {
                // mapView
                descriptionView
            }
            .renderedIf(!transportationInfo.isEmpty)
        }
        .padding(.horizontal, 16)
        .padding(.top, 12)
        .padding(.bottom, 20)
        .background(Color.grey6)
        .clipShape(RoundedRectangle(cornerRadius: 10))
    }
}

private extension TransportationInfoView {
    func icon(type: TransportationType) -> Image {
        switch type {
        case .subway: .iconSubway
        case .bus: .iconBus
        }
    }
}

private extension TransportationInfoView {
    var titleView: some View {
        Text("교통 안내")
            .pretendard(style: .title3)
            .foregroundStyle(Color.white)
            .frame(maxWidth: .infinity, alignment: .leading)
    }
    
    var emptyView: some View {
        Text("아직 등록된 교통 정보가 없어요")
            .pretendard(style: .body0)
            .foregroundStyle(Color.white)
            .frame(maxWidth: .infinity)
    }
    
    var mapView: some View {
        Color.grey4
            .frame(maxWidth: .infinity)
            .frame(height: 226)
            .clipShape(RoundedRectangle(cornerRadius: 5))
    }
    
    var descriptionView: some View {
        Text(transportationInfo)
            .pretendard(style: .body0)
            .foregroundStyle(Color.white)
            .multilineTextAlignment(.leading)
            .frame(maxWidth: .infinity, alignment: .leading)
    }
    
//    var descriptionView: some View {
//        VStack(spacing: 12) {
//            ForEach(0..<transportationList.count, id: \.self) { index in
//                let transportation = transportationList[index]
//                HStack(spacing: 14) {
//                    icon(type: transportation.type)
//                        .resizable()
//                        .frame(width: 25, height: 25)
//                    
//                    Text(transportation.description)
//                        .pretendard(style: .body0)
//                        .foregroundStyle(Color.white)
//                        .multilineTextAlignment(.leading)
//                        .frame(maxWidth: .infinity, alignment: .leading)
//                }
//            }
//        }
//    }
}

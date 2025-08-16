//
//  FestivalView.swift
//  Home
//
//  Created by 이정원 on 8/7/25.
//  Copyright © 2025 Darayo. All rights reserved.
//

import SwiftUI
import ComposableArchitecture
import DesignSystem
import Base

public struct FestivalView: View {
    @Bindable private var store: StoreOf<FestivalFeature>
    @State private var scrollOffset: CGFloat = 0.0
    @Environment(\.openURL) private var openURL
    @Environment(\.scenePhase) private var scenePhase
    private enum ScrollID { case regulationInfo }
    
    public init(store: StoreOf<FestivalFeature>) {
        self.store = store
    }
    
    public var body: some View {
        ZStack(alignment: .top) {
            imageView
            
            ScrollViewReader { proxy in
                scrollView
                    .onChange(of: store.isExpanded) { _, isExpanded in
                        guard isExpanded else { return }
                        withAnimation {
                            proxy.scrollTo(ScrollID.regulationInfo, anchor: .top)
                        }
                    }
            }
            .animation(store.isExpanded ? nil : .default, value: store.isExpanded)
                
            navigationBar
        }
        .navigationBarBackButtonHidden()
        .background(Color.background1)
        .customAlert($store.scope(state: \.alert, action: \.alert), icon: alertIcon)
        .onAppear { store.send(.onAppear) }
        .onChange(of: store.shouldOpenURL) { oldValue, newValue in
            guard !oldValue, newValue else { return }
            store.send(.binding(.set(\.shouldOpenURL, false)))
            guard let url = URL(string: UIApplication.openSettingsURLString) else { return }
            openURL(url)
        }
        .onChange(of: scenePhase) { oldValue, _ in
            guard oldValue == .background else { return }
            store.send(.enteredForeground)
        }
    }
}

private extension FestivalView {
    var alertIcon: Image? {
        return switch store.alert?.alertCase {
        case .authorization: .iconBellGray
        case .like: .iconHeartGray
        case .none: nil
        }
    }
}

private extension FestivalView {
    var scrollView: some View {
        OffsetScrollView(scrollOffset: $scrollOffset) {
            VStack(spacing: 0) {
                Color.clear
                    .frame(height: 256)
                
                VStack(spacing: 12) {
                    festivalInfoView
                    ticketInfoView
                    artistInfoView
                    transportationInfoView
                        .overlay(alignment: .bottom) {
                            Color.clear
                                .frame(height: 56)
                                .id(ScrollID.regulationInfo)
                        }
                        
                    regulationInfoView
                    updateInfoView
                }
                .padding(.horizontal, 16)
            }
            .padding(.bottom, 16)
        }
    }
    
    var imageView: some View {
        GeometryReader { proxy in
            let inset = proxy.safeAreaInsets.top
            
            AsyncImage(url: store.festival.posterURL) { image in
                image
                    .resizable()
                    .scaledToFit()
            } placeholder: {
                let width = proxy.size.width
                Image.placeholder1
                    .resizable()
                    .aspectRatio(contentMode: .fill)
                    .frame(width: width, height: width * 1.2)
            }
            .padding(.top, inset - 100)
            .overlay(alignment: .top) {
                VStack(spacing: 0) {
                    gradient
                        .frame(height: 256 + inset)
                    Color.background1
                }
            }
            .offset(x: 0, y: min(0, -scrollOffset))
            .ignoresSafeArea(edges: .top)
        }
    }
    
    var gradient: some View {
        LinearGradient(
            colors: [.grey6.opacity(0.0), .background1],
            startPoint: .top,
            endPoint: .bottom
        )
    }
    
    var navigationBar: some View {
        let opacity = min(max(0, scrollOffset - 144.0), 56.0) / 56.0
        return HStack(spacing: 20) {
            backButton
            Spacer()
            notificationButton
            heartButton
        }
        .padding(.trailing, 16)
        .background(Color.background1.opacity(opacity))
    }
    
    var backButton: some View {
        Button {
            store.send(.backButtonTapped)
        } label: {
            Image.iconArrowLeft
                .renderingMode(.template)
                .resizable()
                .frame(width: 24, height: 24)
                .foregroundStyle(Color.white)
                .padding(16)
        }
    }
    
    var notificationButton: some View {
        Button {
            store.send(.notificationButtonTapped)
        } label: {
            let image: Image = switch store.isNotificationOn {
            case true: .iconNotificationFill
            case false: .iconNotification
            }
            
            image
                .renderingMode(.template)
                .resizable()
                .frame(width: 24, height: 24)
                .foregroundStyle(Color.white)
                .padding(.vertical, 16)
        }
    }
    
    var heartButton: some View {
        Button {
            store.send(.heartButtonTapped)
        } label: {
            let image: Image = switch store.isFavorite {
            case true: .iconHeartFill
            case false: .iconHeart
            }
            
            return image
                .renderingMode(.template)
                .resizable()
                .frame(width: 24, height: 24)
                .foregroundStyle(Color.white)
                .padding(.vertical, 16)
        }
    }
    
    var festivalInfoView: some View {
        FestivalInfoView(
            title: store.festival.name,
            place: store.festival.placeName,
            dateString: store.dateString,
            urlInfos: store.festival.urlInfos
        )
        .padding(.vertical, 8)
    }
    
    var ticketInfoView: some View {
        TicketInfoView(
            vendors: store.festival.vendors,
            purchaseDates: store.purchaseDates
        )
    }
    
    var artistInfoView: some View {
        ArtistInfoView(artists: store.festival.artists) {
            store.send(.seeAllButtonTapped)
        }
    }
    
    var transportationInfoView: some View {
        TransportationInfoView(
            transportationInfo: store.festival.transportationInfo
        )
    }
    
    var regulationInfoView: some View {
        RegulationInfoView(
            regulation: store.festival.regulation,
            isExpanded: $store.isExpanded
        )
    }
    
    var updateInfoView: some View {
        VStack(spacing: 4) {
            sentenceView("업데이트 일자 : 2025. 06. 15")
            sentenceView("자세한 내용은 공식 사이트 참조")
        }
        .padding(.top, 4)
    }
    
    func sentenceView(_ sentence: String) -> some View {
        HStack(alignment: .top, spacing: 0) {
            Text("•")
                .pretendard(style: .caption2)
                .foregroundStyle(Color.grey5)
                .padding(.horizontal, 8)
            
            Text(sentence)
                .pretendard(style: .caption2)
                .foregroundStyle(Color.grey5)
                .multilineTextAlignment(.leading)
                .frame(maxWidth: .infinity, alignment: .leading)
        }
    }
}

private extension FestivalFeature.AlertCase {
    var title: String {
        switch self {
        case .authorization: "알림 권한이 없어요!"
        case .like: "좋아요가 설정되었어요!"
        }
    }
    
    var message: String {
        "페스티벌 정보를 받으려면\n알림 권한을 허용해주세요"
    }
    
    var buttonTitle: String {
        "권한 설정하기"
    }
}

extension CustomAlert.State {
    init(alertCase: FestivalFeature.AlertCase) {
        self = .init(
            title: alertCase.title,
            message: alertCase.message,
            buttonTitle: alertCase.buttonTitle
        )
    }
    
    var alertCase: FestivalFeature.AlertCase? {
        return FestivalFeature.AlertCase.allCases.first {
            self == .init(alertCase: $0)
        }
    }
}

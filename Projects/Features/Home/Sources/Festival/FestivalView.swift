//
//  FestivalView.swift
//  Home
//
//  Created by 이정원 on 6/29/25.
//  Copyright © 2025 Darayo. All rights reserved.
//

import SwiftUI
import ComposableArchitecture
import DesignSystem
import Domain
import Base

public struct FestivalView: View {
    @Bindable private var store: StoreOf<FestivalFeature>
    @Environment(\.openURL) private var openURL
    @Environment(\.scenePhase) private var scenePhase
    private enum ScrollID { case regulationInfo }
    
    public init(store: StoreOf<FestivalFeature>) {
        self.store = store
    }
    
    public var body: some View {
        VStack(spacing: 0) {
            navigationBar
            GeometryReader { geometryProxy in
                ScrollViewReader { proxy in
                    ScrollView {
                        VStack(spacing: 12) {
                            festivalInfoView
                            ticketInfoView
                            artistInfoView
                            transportationInfoView
                            regulationInfoView
                                .id(ScrollID.regulationInfo)
                        }
                        .padding(.horizontal, 16)
                        .padding(.top, 16)
                        .padding(.bottom, geometryProxy.safeAreaInsets.bottom > 0 ? 0 : 16)
                    }
                    .onChange(of: store.isExpanded) { _, isExpanded in
                        guard isExpanded else { return }
                        withAnimation {
                            proxy.scrollTo(ScrollID.regulationInfo, anchor: .top)
                        }
                    }
                }
                .animation(store.isExpanded ? nil : .default, value: store.isExpanded)
                // timetableButton
            }
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
    var navigationBar: some View {
        HStack(spacing: 20) {
            backButton
            Spacer()
            notificationButton
            heartButton
        }
        .padding(.trailing, 16)
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
            posterURL: store.festival.posterURL
        )
    }
    
    var ticketInfoView: some View {
        TicketInfoView(
            vendors: store.festival.vendors,
            purchaseDates: store.purchaseDates,
            urlInfos: store.festival.urlInfos
        )
    }
    
    var artistInfoView: some View {
        ArtistInfoView(artists: store.festival.artists) {
            store.send(.seeAllButtonTapped)
        }
    }
    
    var transportationInfoView: some View {
        TransportationInfoView(transportationInfo: store.festival.transportationInfo)
    }
    
    var regulationInfoView: some View {
        RegulationInfoView(
            regulation: store.festival.regulation,
            isExpanded: $store.isExpanded
        )
    }
    
    var timetableButton: some View {
        Button("타임테이블") {
            
        }
        .buttonStyle(.festibee)
        .padding(.horizontal, 16)
        .padding(.bottom, 8)
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

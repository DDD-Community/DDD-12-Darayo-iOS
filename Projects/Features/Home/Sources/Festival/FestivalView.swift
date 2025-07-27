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
        .customAlert($store.scope(state: \.alert, action: \.alert), icon: Image.iconBellGray)
        .onAppear { store.send(.onAppear) }
        .onChange(of: store.shouldOpenURL) { oldValue, newValue in
            guard !oldValue, newValue else { return }
            store.send(.binding(.set(\.shouldOpenURL, false)))
            guard let url = URL(string: UIApplication.openSettingsURLString) else { return }
            openURL(url)
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

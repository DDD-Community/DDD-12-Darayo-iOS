//
//  NewFestivalView.swift
//  Home
//
//  Created by 이정원 on 8/7/25.
//  Copyright © 2025 Darayo. All rights reserved.
//

import SwiftUI
import ComposableArchitecture
import DesignSystem

public struct NewFestivalView: View {
    private let store: StoreOf<FestivalFeature>
    @State private var scrollOffset: CGFloat = 0.0
    
    public init(store: StoreOf<FestivalFeature>) {
        self.store = store
    }
    
    public var body: some View {
        ZStack(alignment: .top) {
            imageView
            OffsetScrollView(scrollOffset: $scrollOffset) {
                VStack(spacing: 0) {
                    Color.clear
                        .frame(height: 256)
                    
                    VStack(spacing: 12) {
                        festivalInfoView
                        ticketInfoView
                        artistInfoView
                        transportationInfoView
                    }
                    .padding(.horizontal, 16)
                }
            }
            navigationBar
        }
        .navigationBarBackButtonHidden()
        .background(Color.background1)
    }
}

private extension NewFestivalView {
    var imageView: some View {
        GeometryReader { proxy in
            let inset = proxy.safeAreaInsets.top
            
            ImageView(
                store.festival.posterURL,
                placeholder: .placeholder1
            )
            .scaledToFit()
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
        NewFestivalInfoView(
            title: store.festival.name,
            place: store.festival.placeName,
            dateString: store.dateString,
            urlInfos: store.festival.urlInfos
        )
        .padding(.vertical, 8)
    }
    
    var ticketInfoView: some View {
        NewTicketInfoView(
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
}

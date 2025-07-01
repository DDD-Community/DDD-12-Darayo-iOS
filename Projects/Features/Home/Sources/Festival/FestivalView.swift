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

public struct FestivalView: View {
    private let store: StoreOf<FestivalFeature>
    
    public init(store: StoreOf<FestivalFeature>) {
        self.store = store
    }
    
    public var body: some View {
        VStack(spacing: 0) {
            navigationBar
            ScrollView {
                VStack(spacing: 12) {
                    festivalInfoView
                    ticketInfoView
                    artistInfoView
                }
                .padding(.horizontal, 16)
                .padding(.top, 16)
                .padding(.bottom, 12)
            }
            timetableButton
        }
        .navigationBarBackButtonHidden()
        .background(Color.background1)
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
            title: "인천펜타포트 락 페스티벌",
            place: "송도 달빛축제공원",
            dateString: "2025. 08. 01 (금) - 08. 03 (일)"
        )
    }
    
    var ticketInfoView: some View {
        TicketInfoView(
            vendors: [.yes24, .melon],
            purchaseDates: [
                "2025. 8. 1 (금) - 2025. 8. 3 (일)",
                "2025. 8. 1 (금) - 2025. 8. 3 (일)",
                "2025. 8. 1 (금) - 2025. 8. 3 (일)"
            ],
            platforms: [.instagram, .website]
        )
    }
    
    var artistInfoView: some View {
        ArtistInfoView(
            artists: .init(
                repeating: .init(name: "아티스트명", imageURLString: ""),
                count: 10
            )
        ) {
            
        }
    }
    
    var timetableButton: some View {
        Button("타임테이블") {
            
        }
        .buttonStyle(.festibee)
        .padding(.horizontal, 16)
        .padding(.bottom, 8)
    }
}

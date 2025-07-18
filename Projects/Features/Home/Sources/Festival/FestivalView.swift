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
    @Bindable private var store: StoreOf<FestivalFeature>
    private enum ScrollID { case bottom }
    
    public init(store: StoreOf<FestivalFeature>) {
        self.store = store
    }
    
    public var body: some View {
        VStack(spacing: 0) {
            navigationBar
            ScrollViewReader { proxy in
                ScrollView {
                    VStack(spacing: 12) {
                        festivalInfoView
                        ticketInfoView
                        artistInfoView
                        transportationInfoView
                        regulationInfoView
                        
                        Color.clear
                            .frame(height: 0)
                            .id(ScrollID.bottom)
                    }
                    .padding(.horizontal, 16)
                    .padding(.top, 16)
                }
                .onChange(of: store.isExpanded) { _, isExpanded in
                    guard isExpanded else { return }
                    withAnimation {
                        proxy.scrollTo(ScrollID.bottom, anchor: .bottom)
                    }
                }
                .animation(store.isExpanded ? nil : .default, value: store.isExpanded)
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
            title: store.festival.name,
            place: store.festival.placeName,
            dateString: store.dateString,
            posterURL: store.festival.posterURL
        )
    }
    
    var ticketInfoView: some View {
        TicketInfoView(
            vendors: [.yes24, .melon],
            purchaseDates: store.purchaseDates,
            platforms: [.instagram, .website]
        )
    }
    
    var artistInfoView: some View {
        ArtistInfoView(artists: store.festival.artists) {
            store.send(.seeAllButtonTapped)
        }
    }
    
    var transportationInfoView: some View {
        TransportationInfoView(
            transportationList: [
                .init(
                    type: .subway,
                    description: "인천지하철 1호선 송도달빛축제공원역\n4번출구에서 도보 이동"
                ),
                .init(
                    type: .bus,
                    description: "송도달빛축제공원 정류장 (순환42)"
                ),
                .init(
                    type: .bus,
                    description: "펜타포트 공식 셔틀버스 (추후 공지)"
                ),
            ]
        )
    }
    
    var regulationInfoView: some View {
        let regulation = """
        안전사고 예방과 원활한 진행을 위해 모든 공연장 입구에서 반입 금지 물품을 검사 진행
        외부음식, 패스트푸드, 배달음식, 유리병/캔 으료 등 모든 외부 음식물의 반입 금지
        공연장 내에는 500ml 이하의 페트병(1인당 1개에 한함) 또는 개인 텀블러에 담긴 물을 제외한 모든 주류 및 음료 반입 금지
        실내공연장의 경우, 500ml 이하의 페트병(1인당 1개에 한함)을 제외한 식음료의 공연장 내 반입 금지
        공연장 내로 반입이 금지된 음식은 공연장 외부 관객 휴식 공간에서 드시고 입장 필요
        20L를 초과하는 대형 아이스박스는 반입이 불가
        휴대용 의자는 다리가 없는 경우에 한해 특정공간에서만 허용되며, 주위 관객들에게 피해가 되거나 운영상 필요 시, 위치 이동 혹은 철거 조치 (캠핑의자, 에어베드 등 반입 불가)
        불꽃놀이 등의 화약류, 마약류 등 기타 위험물로 분류된 물품과 타인에게 위협이 될 수 있는 소지품의 반입은 불가
        공연장 내에서는 텐트/그늘막/취사도구/캠핑용품 등의 사용이 금지되며 확인 시 철거 조치
        유모차와 휱체어를 제외한 바퀴가 달린 물품의 반입은 금지
        유모차와 휠체어는 안전과 원활한 운영을 위하여 일부 구역으로 제한되오니 현장 진행요원의 안내에 협조해 주시기 바랍니다.
        반려동물은 아쉽게도 공연장 내로 동행 불가
        """
        
        return RegulationInfoView(
            regulation: regulation,
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

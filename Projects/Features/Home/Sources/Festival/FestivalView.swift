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

public struct FestivalView: View {
    private let store: StoreOf<FestivalFeature>
    
    public init(store: StoreOf<FestivalFeature>) {
        self.store = store
    }
    
    public var body: some View {
        VStack(spacing: 0) {
            navigationBar
            Spacer()
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
            
        } label: {
            Image.iconNotification
                .renderingMode(.template)
                .resizable()
                .frame(width: 24, height: 24)
                .foregroundStyle(Color.white)
                .padding(.vertical, 16)
        }
    }
    
    var heartButton: some View {
        Button {
            
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
}

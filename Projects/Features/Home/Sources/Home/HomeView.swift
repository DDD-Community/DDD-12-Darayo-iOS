//
//  HomeView.swift
//  Home
//
//  Created by 이정원 on 6/22/25.
//  Copyright © 2025 Darayo. All rights reserved.
//

import SwiftUI
import ComposableArchitecture
import DesignSystem
import Base

public struct HomeView: View {
    private let store: StoreOf<HomeFeature>
    
    public init(store: StoreOf<HomeFeature>) {
        self.store = store
    }
    
    public var body: some View {
        VStack(spacing: 0) {
            navigationBar
            HomeGridView(store: store)
        }
        .background(Color.background1)
        .onAppear { store.send(.onAppear) }
    }
}

private extension HomeView {
    var navigationBar: some View {
        HStack {
            Image.logo
                .resizable()
                .aspectRatio(contentMode: .fit)
                .frame(width: 106)
                .padding(.leading, 16)
            
            Spacer()
            myPageButton
        }
    }
    
    var myPageButton: some View {
        Button {
            store.send(.myPageButtonTapped)
        } label: {
            Image.iconMyPage
                .renderingMode(.template)
                .resizable()
                .frame(width: 24, height: 24)
                .foregroundStyle(Color.grey4)
                .padding(16)
        }
    }
}

extension HomeFeature.AlertCase: AlertPresentable {
    public var alertInfo: AlertInfo {
        switch self {
        case .error(let error):
            switch error.type {
            case .noInternet: return .noInternet
            default: return .error(error, buttonTitle: "확인")
            }
        }
    }
}

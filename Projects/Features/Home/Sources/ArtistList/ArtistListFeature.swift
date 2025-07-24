//
//  ArtistListFeature.swift
//  Home
//
//  Created by 이정원 on 7/2/25.
//  Copyright © 2025 Darayo. All rights reserved.
//

import Foundation
import ComposableArchitecture
import Domain

@Reducer
public struct ArtistListFeature {
    @Dependency(\.dismiss) private var dismiss
    
    @ObservableState
    public struct State {
        var tabIndex: Int = 0
        var sectionToScroll: Int?
        var artists: [[Artist]]
        
        public init(artists: [Artist]) {
            self.artists = Dictionary(grouping: artists) { artist in
                artist.performanceDate ?? Date.distantFuture
            }
            .sorted { $0.key < $1.key }
            .map { $0.value }
        }
        
        var totalDays: Int {
            artists.count
        }
    }
    
    public enum Action: BindableAction {
        case backButtonTapped
        case dayButtonTapped(Int)
        case indexChanged(Int)
        case binding(BindingAction<State>)
    }
    
    public init() {}
    public var body: some ReducerOf<Self> {
        BindingReducer()
        
        Reduce { state, action in
            switch action {
            case .backButtonTapped:
                return .run { _ in await dismiss() }
            case .dayButtonTapped(let index):
                state.sectionToScroll = index
                return .none
            case .indexChanged(let index):
                state.tabIndex = index
                return .none
            case .binding: return .none
            }
        }
    }
}

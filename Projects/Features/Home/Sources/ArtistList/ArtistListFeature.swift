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
        var indexToScroll: (Int, Date)?
        var artists: [[Artist]]
        
        public init() {
            let count = (1...4).randomElement()!
            let artist = Artist(
                name: (0..<count).map { _ in "아티스트명" }.joined(),
                imageURLString: ""
            )
            
            self.artists = .init(
                repeating: .init(
                    repeating: artist,
                    count: (1...12).randomElement()!
                ),
                count: (1...8).randomElement()!
            )
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
                state.indexToScroll = (index, .now)
                return .none
            case .indexChanged(let index):
                state.tabIndex = index
                return .none
            case .binding: return .none
            }
        }
    }
}

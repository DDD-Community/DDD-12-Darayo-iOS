//
//  ArtistListFeature.swift
//  Home
//
//  Created by 이정원 on 7/2/25.
//  Copyright © 2025 Darayo. All rights reserved.
//

import ComposableArchitecture
import Domain

@Reducer
public struct ArtistListFeature {
    @Dependency(\.dismiss) private var dismiss
    
    @ObservableState
    public struct State {
        var totalDays: Int = 6
        var selectedIndex: Int = 0
        
        var artists: [[Artist]] = [
            .init(
                repeating: .init(name: "아티스트명아티스트명아티스트명아티스트명", imageURLString: ""),
                count: 11
            ),
            .init(
                repeating: .init(name: "아티스트명", imageURLString: ""),
                count: 9
            ),
            .init(
                repeating: .init(name: "아티스트명", imageURLString: ""),
                count: 7
            ),
            .init(
                repeating: .init(name: "아티스트명아티스트명아티스트명아티스트명", imageURLString: ""),
                count: 5
            ),
            .init(
                repeating: .init(name: "아티스트명", imageURLString: ""),
                count: 3
            ),
            .init(
                repeating: .init(name: "아티스트명", imageURLString: ""),
                count: 1
            )
        ]
        
        public init() {}
    }
    
    public enum Action {
        case backButtonTapped
        case dayButtonTapped(Int)
    }
    
    public init() {}
    public var body: some ReducerOf<Self> {
        Reduce { state, action in
            switch action {
            case .backButtonTapped:
                return .run { _ in await dismiss() }
            case .dayButtonTapped(let index):
                state.selectedIndex = index
                return .none
            }
        }
    }
}

//
//  SelectArtistFeature.swift
//  Timetable
//
//  Created by 이정원 on 7/4/25.
//  Copyright © 2025 Darayo. All rights reserved.
//

import ComposableArchitecture
import Domain

@Reducer
public struct SelectArtistFeature {
    @Dependency(\.dismiss) private var dismiss
    
    @ObservableState
    public struct State {
        var artists: [Artist]
        var selectedArtists: Set<Artist>
        
        public init(
            _ artists: [Artist],
            _ selectedArtists: Set<Artist>
        ) {
            self.artists = artists
            self.selectedArtists = selectedArtists
        }
    }
    
    public enum Action {
        case closeButtonTapped
        case artistButtonTapped(Artist)
        case doneButtonTapped
    }
    
    public init() {}
    public var body: some ReducerOf<Self> {
        Reduce { state, action in
            switch action {
            case .closeButtonTapped:
                return .run { _ in await dismiss() }
            case .artistButtonTapped(let artist):
                switch state.selectedArtists.contains(artist) {
                case true: state.selectedArtists.remove(artist)
                case false: state.selectedArtists.insert(artist)
                }
                return .none
            case .doneButtonTapped: return .none
            }
        }
    }
}

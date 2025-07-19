//
//  TimetableFeature.swift
//  Timetable
//
//  Created by 이정원 on 6/23/25.
//  Copyright © 2025 Darayo. All rights reserved.
//

import Foundation
import ComposableArchitecture
import Domain

@Reducer
public struct TimetableFeature {
    @ObservableState
    public struct State {
        var festivalName: String = "서울 재즈 페스티벌"
        var dateString: String = "25.08.08 (금)"
        
        var artists: [Artist] = (0..<15).map { _ in
            .init(
                id: UUID().uuidString,
                name: "아티스트명",
                performanceDate: nil
            )
        }
        var selectedArtists: Set<Artist> = .init()
        
        @Presents var path: Path.State?
        public init() {}
    }
    
    public enum Action {
        case festivalButtonTapped
        case filterButtonTapped
        case path(PresentationAction<Path.Action>)
    }
    
    public init() {}
    public var body: some ReducerOf<Self> {
        Reduce { state, action in
            switch action {
            case .festivalButtonTapped:
                let festivalName = state.festivalName
                state.path = .selectFestival(.init(selectedFestival: festivalName))
                return .none
            case .filterButtonTapped:
                let artists = state.artists
                let selectedArtists = state.selectedArtists
                state.path = .selectArtist(.init(artists, selectedArtists))
                return .none
            case .path(.presented(.selectFestival(.doneButtonTapped))):
                let name = state.path?.selectFestival?.selectedFestival
                if let name { state.festivalName = name }
                return .none
            case .path(.presented(.selectArtist(.doneButtonTapped))):
                let artists = state.path?.selectArtist?.selectedArtists
                if let artists { state.selectedArtists = artists }
                state.path = nil
                return .none
            case .path: return .none
            }
            
        }
        .ifLet(\.$path, action: \.path)
    }
}

extension TimetableFeature {
    @Reducer
    public enum Path {
        case selectFestival(SelectFestivalFeature)
        case selectArtist(SelectArtistFeature)
    }
}

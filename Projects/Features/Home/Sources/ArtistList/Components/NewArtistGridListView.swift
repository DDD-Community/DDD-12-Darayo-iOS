//
//  NewArtistGridListView.swift
//  Home
//
//  Created by 이정원 on 7/20/25.
//  Copyright © 2025 Darayo. All rights reserved.
//

import SwiftUI
import Domain

struct NewArtistGridListView: UIViewRepresentable {
    private let artists: [[Artist]]
    
    init(artists: [[Artist]]) {
        self.artists = artists
    }
    
    func makeUIView(context: Context) -> UICollectionView {
        let collectionView = ArtistCollectionView()
        collectionView.delegate = context.coordinator
        collectionView.dataSource = context.coordinator
        return collectionView
    }
    
    func updateUIView(_ uiView: UICollectionView, context: Context) {
        
    }
    
    func makeCoordinator() -> Coordinator {
        Coordinator(artists: artists)
    }
}

extension NewArtistGridListView {
    final class Coordinator: NSObject, UICollectionViewDataSource, UICollectionViewDelegate {
        private let artists: [[Artist]]
        
        init(artists: [[Artist]]) {
            self.artists = artists
        }
        
        func numberOfSections(in collectionView: UICollectionView) -> Int {
            return artists.count
        }
        
        func collectionView(
            _ collectionView: UICollectionView,
            numberOfItemsInSection section: Int
        ) -> Int {
            return artists[section].count
        }
        
        func collectionView(
            _ collectionView: UICollectionView,
            cellForItemAt indexPath: IndexPath
        ) -> UICollectionViewCell {
            let artist = artists[indexPath.section][indexPath.item]
            let cell = collectionView.dequeueReusableCell(
                withReuseIdentifier: ArtistCell.identifier, for: indexPath
            )
            
            if let artistCell = cell as? ArtistCell {
                artistCell.configure(artist: artist)
                return artistCell
            }
            return cell
        }
        
        func collectionView(
            _ collectionView: UICollectionView,
            viewForSupplementaryElementOfKind kind: String,
            at indexPath: IndexPath
        ) -> UICollectionReusableView {
            let view = collectionView.dequeueReusableSupplementaryView(
                ofKind: kind,
                withReuseIdentifier: DayHeaderView.identifier,
                for: indexPath
            )
            
            if let dayHeaderReusableView = view as? DayHeaderView {
                dayHeaderReusableView.configure(dayNumber: indexPath.section + 1)
                return dayHeaderReusableView
            }
            return view
        }
    }
}

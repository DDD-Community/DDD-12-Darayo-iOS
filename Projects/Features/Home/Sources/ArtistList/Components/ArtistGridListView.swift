//
//  ArtistGridListView.swift
//  Home
//
//  Created by 이정원 on 7/20/25.
//  Copyright © 2025 Darayo. All rights reserved.
//

import SwiftUI
import Domain

struct ArtistGridListView: UIViewRepresentable {
    private let durationKey = "contentOffsetAnimationDuration"
    private let artists: [[Artist]]
    @Binding private var sectionToScroll: Int?
    private let onSectionChanged: (Int) -> Void
    
    init(
        artists: [[Artist]],
        sectionToScroll: Binding<Int?>,
        onSectionChanged: @escaping (Int) -> Void
    ) {
        self.artists = artists
        self._sectionToScroll = sectionToScroll
        self.onSectionChanged = onSectionChanged
    }
    
    func makeUIView(context: Context) -> UICollectionView {
        let collectionView = ArtistCollectionView(sectionCount: artists.count)
        collectionView.delegate = context.coordinator
        collectionView.dataSource = context.coordinator
        return collectionView
    }
    
    func updateUIView(_ uiView: UICollectionView, context: Context) {
        guard let sectionToScroll else { return }
        self.sectionToScroll = nil
        scrollToSectionHeader(collectionView: uiView, section: sectionToScroll)
    }
    
    func makeCoordinator() -> Coordinator {
        Coordinator(
            artists: artists,
            onSectionChanged: onSectionChanged
        )
    }
}

private extension ArtistGridListView {
    func scrollToSectionHeader(collectionView: UICollectionView, section: Int) {
        let indexPath = IndexPath(item: 0, section: section)
            
        let headerLayout = collectionView.layoutAttributesForSupplementaryElement(
            ofKind: UICollectionView.elementKindSectionHeader,
            at: indexPath
        )
        
        let offset: CGPoint? = switch headerLayout {
        case .some(let layout): layout.frame.origin
        case .none: collectionView.frame.origin
        }
        
        if let offset {
            collectionView.setValue(0.3, forKeyPath: durationKey)
            collectionView.setContentOffset(offset, animated: true)
            DispatchQueue.main.asyncAfter(wallDeadline: .now() + 0.35) {
                onSectionChanged(section)
            }
        }
    }
}

extension ArtistGridListView {
    final class Coordinator: NSObject, UICollectionViewDataSource, UICollectionViewDelegate {
        private let artists: [[Artist]]
        private let onSectionChanged: (Int) -> Void
        
        init(
            artists: [[Artist]],
            onSectionChanged: @escaping (Int) -> Void
        ) {
            self.artists = artists
            self.onSectionChanged = onSectionChanged
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
        
        func scrollViewDidScroll(_ scrollView: UIScrollView) {
            guard let collectionView = scrollView as? UICollectionView else { return }
            let offsetY = collectionView.contentOffset.y
            
            let headers = collectionView
                .collectionViewLayout
                .layoutAttributesForElements(in: collectionView.bounds)?
                .filter { $0.representedElementKind == UICollectionView.elementKindSectionHeader }
            guard let headers else { return }
            
            let section = getSection(headers: headers, offsetY: offsetY)
            guard let section else { return }
            onSectionChanged(section)
        }
        
        func getSection(
            headers: [UICollectionViewLayoutAttributes],
            offsetY: CGFloat
        ) -> Int? {
            if headers.isEmpty { return nil }
            
            if offsetY < headers[0].frame.origin.y {
                return max(0, headers[0].indexPath.section - 1)
            }
            
            if offsetY >= headers[headers.count - 1].frame.origin.y {
                return headers[headers.count - 1].indexPath.section
            }
            
            let index = headers.indices.first { index in
                let start = headers[index].frame.origin.y
                let end = headers[index + 1].frame.origin.y
                return start..<end ~= offsetY
            }
            
            guard let index else { return nil }
            return headers[index].indexPath.section
        }
    }
}

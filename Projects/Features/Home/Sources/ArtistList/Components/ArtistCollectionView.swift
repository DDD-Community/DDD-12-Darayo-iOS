//
//  ArtistCollectionView.swift
//  Home
//
//  Created by 이정원 on 7/20/25.
//  Copyright © 2025 Darayo. All rights reserved.
//

import UIKit
import DesignSystem

final class ArtistCollectionView: UICollectionView {
    private let sectionCount: Int
    private let containsNil: Bool
    
    init(
        sectionCount: Int,
        containsNil: Bool
    ) {
        self.sectionCount = sectionCount
        self.containsNil = containsNil
        super.init(frame: .zero, collectionViewLayout: .init())
        backgroundColor = .background1
        register()
        collectionViewLayout = compositionalLayout
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        updateBottomInset(sectionCount)
    }
}

private extension ArtistCollectionView {
    func register() {
        register(ArtistCell.self, forCellWithReuseIdentifier: ArtistCell.identifier)
        register(
            DayHeaderView.self,
            forSupplementaryViewOfKind: UICollectionView.elementKindSectionHeader,
            withReuseIdentifier: DayHeaderView.identifier
        )
    }
    
    var item: NSCollectionLayoutItem {
        return .init(
            layoutSize: .init(
                widthDimension: .fractionalWidth(1.0 / 3.0),
                heightDimension: .estimated(142)
            )
        )
    }
    
    var group: NSCollectionLayoutGroup {
        let group = NSCollectionLayoutGroup.horizontal(
            layoutSize: .init(
                widthDimension: .fractionalWidth(1.0),
                heightDimension: .estimated(150)
            ),
            repeatingSubitem: item,
            count: 3
        )
        
        group.interItemSpacing = .fixed(20)
        group.contentInsets = .init(top: 0, leading: 16, bottom: 0, trailing: 16)
        return group
    }
    
    var header: NSCollectionLayoutBoundarySupplementaryItem {
        return .init(
            layoutSize: .init(
                widthDimension: .fractionalWidth(1.0),
                heightDimension: .estimated(29)
            ),
            elementKind: UICollectionView.elementKindSectionHeader,
            alignment: .top
        )
    }
    
    var section: NSCollectionLayoutSection {
        let section = NSCollectionLayoutSection(group: group)
        section.boundarySupplementaryItems = sectionCount > 1 ? [header] : []
        section.interGroupSpacing = 16
        section.contentInsets = .init(top: 16, leading: 0, bottom: 52, trailing: 0)
        return section
    }
    
    var compositionalLayout: UICollectionViewCompositionalLayout {
        return .init(section: section)
    }
    
    func updateBottomInset(_ sectionCount: Int) {
        let lastSection = sectionCount - 1
        let lastItem = numberOfItems(inSection: lastSection) - 1
        guard lastSection >= 0 , lastItem >= 0 else { return }
        
        let headerAttributes = layoutAttributesForSupplementaryElement(
            ofKind: UICollectionView.elementKindSectionHeader,
            at: IndexPath(item: 0, section: lastSection)
        )
        
        let lastCellAttributes = layoutAttributesForItem(
            at: IndexPath(item: lastItem, section: lastSection)
        )
        
        guard let headerAttributes, let lastCellAttributes else { return }
        let sectionHeight = lastCellAttributes.frame.maxY - headerAttributes.frame.minY
        let bottomInset = max(0, bounds.height - sectionHeight - 52 - safeAreaInsets.bottom)
        contentInset.bottom = bottomInset
    }
}

//
//  ArtistCell.swift
//  Home
//
//  Created by 이정원 on 7/20/25.
//  Copyright © 2025 Darayo. All rights reserved.
//

import UIKit
import SwiftUI
import Domain
import DesignSystem

final class ArtistCell: UICollectionViewCell {
    static let identifier = String(describing: ArtistCell.self)
    
    private let imageView: UIImageView = {
        let imageView = UIImageView()
        imageView.image = UIImage.iconArtistPlaceholder
        imageView.translatesAutoresizingMaskIntoConstraints = false
        return imageView
    }()
    
    private let nameLabel: UILabel = {
        let label = UILabel()
        label.font = Pretendard.medium.font(size: 14)
        label.numberOfLines = 2
        label.textColor = .white
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        configureLayouts()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        configureLayouts()
    }
    
    func configure(artist: Artist) {
        nameLabel.text = artist.name
        nameLabel.lineHeight(14 * 1.3)
    }
}

private extension ArtistCell {
    func configureLayouts() {
        contentView.backgroundColor = .background1
        contentView.addSubview(imageView)
        contentView.addSubview(nameLabel)
        
        NSLayoutConstraint.activate([
            imageView.topAnchor.constraint(equalTo: contentView.topAnchor),
            imageView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
            imageView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor),
            imageView.heightAnchor.constraint(equalTo: imageView.widthAnchor),
            
            nameLabel.topAnchor.constraint(equalTo: imageView.bottomAnchor, constant: 6),
            nameLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
            nameLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor),
            nameLabel.bottomAnchor.constraint(lessThanOrEqualTo: contentView.bottomAnchor)
        ])
    }
}

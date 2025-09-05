//
//  DayHeaderView.swift
//  Home
//
//  Created by 이정원 on 7/20/25.
//  Copyright © 2025 Darayo. All rights reserved.
//

import UIKit
import SwiftUI
import DesignSystem

final class DayHeaderView: UICollectionReusableView {
    static let identifier = String(describing: DayHeaderView.self)
    
    private let titleLabel: UILabel = {
        let label = UILabel()
        label.font = Pretendard.bold.font(size: 22)
        label.textColor = .point1
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
    
    func configure(dayNumber: Int?) {
        titleLabel.text = switch dayNumber {
        case .some(let dayNumber): "DAY\(dayNumber)"
        case .none: "일정 미정"
        }
        titleLabel.lineHeight(22 * 1.3)
    }
}

private extension DayHeaderView {
    func configureLayouts() {
        addSubview(titleLabel)
        
        NSLayoutConstraint.activate([
            titleLabel.topAnchor.constraint(equalTo: topAnchor),
            titleLabel.bottomAnchor.constraint(equalTo: bottomAnchor),
            titleLabel.leadingAnchor.constraint(equalTo: leadingAnchor),
            titleLabel.trailingAnchor.constraint(equalTo: trailingAnchor)
        ])
    }
}

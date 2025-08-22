//
//  RootFeature+AlertCase.swift
//  Root
//
//  Created by 이정원 on 8/22/25.
//  Copyright © 2025 Darayo. All rights reserved.
//

import ComposableArchitecture
import Home

extension RootFeature {
    public enum AlertCase: Equatable {
        case main(MainFeature.AlertCase)
    }
}

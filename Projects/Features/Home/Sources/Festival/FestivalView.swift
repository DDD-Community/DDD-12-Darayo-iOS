//
//  FestivalView.swift
//  Home
//
//  Created by 이정원 on 6/29/25.
//  Copyright © 2025 Darayo. All rights reserved.
//

import SwiftUI
import ComposableArchitecture
import DesignSystem

public struct FestivalView: View {
    private let store: StoreOf<FestivalFeature>
    
    public init(store: StoreOf<FestivalFeature>) {
        self.store = store
    }
    
    public var body: some View {
        Text("FestivalView")
            .pretendard(style: .title1)
    }
}

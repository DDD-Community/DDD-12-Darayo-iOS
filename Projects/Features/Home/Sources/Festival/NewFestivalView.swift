//
//  NewFestivalView.swift
//  Home
//
//  Created by 이정원 on 8/7/25.
//  Copyright © 2025 Darayo. All rights reserved.
//

import SwiftUI
import ComposableArchitecture
import DesignSystem

public struct NewFestivalView: View {
    private let store: StoreOf<FestivalFeature>
    
    public init(store: StoreOf<FestivalFeature>) {
        self.store = store
    }
    
    public var body: some View {
        Text("New Festival View")
            .frame(maxWidth: .infinity, maxHeight: .infinity)
            .background(Color.background1)
    }
}

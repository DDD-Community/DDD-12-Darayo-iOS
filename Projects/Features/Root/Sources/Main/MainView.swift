//
//  MainView.swift
//  Root
//
//  Created by 이정원 on 6/21/25.
//  Copyright © 2025 Darayo. All rights reserved.
//

import SwiftUI
import ComposableArchitecture
import DesignSystem

public struct MainView: View {
    private let store: StoreOf<MainFeature>
    
    public init(store: StoreOf<MainFeature>) {
        self.store = store
    }
    
    public var body: some View {
        ZStack(alignment: .bottom) {
            TabView(selection: <#T##Binding<Hashable>#>, content: <#T##() -> TabContent#>)
        }
    }
}

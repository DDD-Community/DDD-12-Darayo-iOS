//
//  DarayoApp.swift
//  Darayo
//
//  Created by 이정원 on 6/1/25.
//  Copyright © 2025 Darayo. All rights reserved.
//

import SwiftUI
import Root

@main
struct DarayoApp: App {
    var body: some Scene {
        WindowGroup {
            RootView(
                store: .init(initialState: .init()) {
                    RootFeature()
                }
            )
        }
    }
}

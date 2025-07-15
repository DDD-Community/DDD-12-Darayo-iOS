//
//  FestibeeApp.swift
//  Darayo
//
//  Created by 이정원 on 6/1/25.
//  Copyright © 2025 Darayo. All rights reserved.
//

import SwiftUI
import Root
import DesignSystem

@main
struct FestibeeApp: App {
    @UIApplicationDelegateAdaptor private var appDelegate: AppDelegate
    
    init() {
        DesignSystemFontFamily.registerAllCustomFonts()
    }
    
    var body: some Scene {
        WindowGroup {
            RootView(
                store: .init(initialState: .init()) {
                    RootFeature()
                }
            )
            .overlay(alignment: .bottom) {
                Banner()
            }
            .preferredColorScheme(.dark)
        }
    }
}

extension UINavigationController {
    open override func viewDidLoad() {
        super.viewDidLoad()
        interactivePopGestureRecognizer?.delegate = nil
    }
}

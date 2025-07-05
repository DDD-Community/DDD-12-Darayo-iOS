//
//  DesignSystemDemoApp.swift
//  DesignSystemDemo
//
//  Created by 이정원 on 6/14/25.
//  Copyright © 2025 Darayo. All rights reserved.
//

import SwiftUI
import DesignSystem

@main
struct DesignSystemDemoApp: App {
    init() {
        DesignSystemFontFamily.registerAllCustomFonts()
    }
    
    var body: some Scene {
        WindowGroup {
            NavigationStack {
                demoList
            }
        }
    }
}

private extension DesignSystemDemoApp {
    var demoList: some View {
        List {
            NavigationLink("Icon Button") {
                IconButtonDemoView()
            }
            
            NavigationLink("Timetable") {
                TimetableDemoView()
            }
            
            NavigationLink("Calendar") {
                CalendarDemoView()
            }
        }
        .navigationTitle("Design System")
    }
}

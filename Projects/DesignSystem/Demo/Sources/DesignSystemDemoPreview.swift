//
//  DesignSystemDemoPreview.swift
//  DesignSystemDemo
//
//  Created by 이다영 on 6/21/25.
//  Copyright © 2025 Darayo. All rights reserved.
//

import SwiftUI
import DesignSystem

struct DesignSystemDemoPreview: View {
    var body: some View {
        NavigationStack {
            List {
                NavigationLink("Icon Button") {
                    IconButtonDemoView()
                }

                NavigationLink("Timetable") {
                    TimetableDemoView()
                }
            }
            .navigationTitle("Design System")
        }
    }
}

struct DesignSystemDemoPreview_Previews: PreviewProvider {
    static var previews: some View {
        DesignSystemDemoPreview()
    }
}

struct IconButtonDemoView_Previews: PreviewProvider {
    static var previews: some View {
        IconButtonDemoView()
            .padding()
            .previewDisplayName("Icon Button Demo")
    }
}

struct TimetableDemoView_Previews: PreviewProvider {
    static var previews: some View {
        TimetableDemoView()
            .padding()
            .previewDisplayName("Timetable Demo")
    }
}

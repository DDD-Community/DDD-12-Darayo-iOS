//
//  SafariView.swift
//  DesignSystem
//
//  Created by 이정원 on 7/6/25.
//  Copyright © 2025 Darayo. All rights reserved.
//

import SwiftUI
import SafariServices

struct SafariView: UIViewControllerRepresentable {
    private let url: URL
    
    init(url: URL) {
        self.url = url
    }
    
    func makeUIViewController(context: Context) -> SFSafariViewController {
        return SFSafariViewController(url: url)
    }
    
    func updateUIViewController(_ uiViewController: SFSafariViewController, context: Context) {}
}

public extension View {
    func safari(url urlBinding: Binding<URL?>) -> some View {
        sheet(item: urlBinding) { url in
            SafariView(url: url)
        }
    }
}

extension URL: @retroactive Identifiable {
    public var id: Self { self }
}

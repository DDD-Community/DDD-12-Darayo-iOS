//
//  ImageView.swift
//  DesignSystem
//
//  Created by 이정원 on 8/1/25.
//  Copyright © 2025 Darayo. All rights reserved.
//

import SwiftUI

public struct ImageView: View {
    private let url: URL?
    private let placeholder: Image
    
    public init(
        _ url: URL?,
        placeholder: Image
    ) {
        self.url = url
        self.placeholder = placeholder
    }
    
    public var body: some View {
        AsyncImage(url: url) { image in
            image
                .resizable()
        } placeholder: {
            placeholder
                .resizable()
        }
    }
}

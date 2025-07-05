//
//  InquiryView.swift
//  MyPage
//
//  Created by 이정원 on 7/6/25.
//  Copyright © 2025 Darayo. All rights reserved.
//

import SwiftUI
import ComposableArchitecture

public struct InquiryView: View {
    private let store: StoreOf<InquiryFeature>
    
    public init(store: StoreOf<InquiryFeature>) {
        self.store = store
    }
    
    public var body: some View {
        VStack {
            Text("Inquiry")
        }
    }
}

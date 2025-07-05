//
//  TermsOfServiceView.swift
//  MyPage
//
//  Created by 이정원 on 7/6/25.
//  Copyright © 2025 Darayo. All rights reserved.
//

import SwiftUI
import ComposableArchitecture

public struct TermsOfServiceView: View {
    private let store: StoreOf<TermsOfServiceFeature>
    
    public init(store: StoreOf<TermsOfServiceFeature>) {
        self.store = store
    }
    
    public var body: some View {
        VStack {
            Text("Terms of Service")
        }
    }
}

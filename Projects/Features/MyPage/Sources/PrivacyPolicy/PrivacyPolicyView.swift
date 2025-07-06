//
//  PrivacyPolicyView.swift
//  MyPage
//
//  Created by 이정원 on 7/6/25.
//  Copyright © 2025 Darayo. All rights reserved.
//

import SwiftUI
import ComposableArchitecture

public struct PrivacyPolicyView: View {
    private let store: StoreOf<PrivacyPolicyFeature>
    
    public init(store: StoreOf<PrivacyPolicyFeature>) {
        self.store = store
    }
    
    public var body: some View {
        VStack {
            Text("Privacy Policy")
        }
    }
}

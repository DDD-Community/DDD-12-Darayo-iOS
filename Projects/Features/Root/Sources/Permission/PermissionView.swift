//
//  PermissionView.swift
//  Root
//
//  Created by 이정원 on 6/21/25.
//  Copyright © 2025 Darayo. All rights reserved.
//

import SwiftUI
import ComposableArchitecture

public struct PermissionView: View {
    private let store: StoreOf<PermissionFeature>
    
    public init(store: StoreOf<PermissionFeature>) {
        self.store = store
    }
    
    public var body: some View {
        Text("PermissionView")
    }
}

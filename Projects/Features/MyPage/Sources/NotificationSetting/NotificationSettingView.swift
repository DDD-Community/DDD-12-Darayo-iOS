//
//  NotificationSettingView.swift
//  MyPage
//
//  Created by 이정원 on 7/5/25.
//  Copyright © 2025 Darayo. All rights reserved.
//

import SwiftUI
import ComposableArchitecture

public struct NotificationSettingView: View {
    private let store: StoreOf<NotificationSettingFeature>
    
    public init(store: StoreOf<NotificationSettingFeature>) {
        self.store = store
    }
    
    public var body: some View {
        VStack {
            Text("Notification Setting")
        }
    }
}

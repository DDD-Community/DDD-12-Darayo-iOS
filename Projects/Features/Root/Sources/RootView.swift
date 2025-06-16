//
//  RootView.swift
//  Root
//
//  Created by 이정원 on 6/8/25.
//  Copyright © 2025 Darayo. All rights reserved.
//

import SwiftUI
import ComposableArchitecture
import Domain

public struct RootView: View {
    private let store: StoreOf<RootFeature>
    
    public init(store: StoreOf<RootFeature>) {
        self.store = store
    }
    
    public var body: some View {
        ZStack {
            NavigationStack {
                ScrollView {
                    coffeeListView
                }
                .navigationTitle("Coffee")
            }
            
            if store.isLoading {
                ProgressView()
            }
        }
        .onAppear { store.send(.onAppear) }
    }
}

private extension RootView {
    var titleView: some View {
        Text("Coffee")
            .font(.system(.title))
            .frame(maxWidth: .infinity, alignment: .leading)
            .padding(.horizontal, 20)
    }
    
    var coffeeListView: some View {
        LazyVStack(spacing: 0) {
            ForEach(0..<store.coffeeList.count, id: \.self) { index in
                let coffee = store.coffeeList[index]
                VStack(spacing: 0) {
                    coffeeView(coffee: coffee)
                    if index < store.coffeeList.count - 1 {
                        divider
                    }
                }
            }
        }
    }
    
    func coffeeView(coffee: Coffee) -> some View {
        HStack(alignment: .top, spacing: 20) {
            AsyncImage(url: URL(string: coffee.imageURLString)) { image in
                image
                    .resizable()
                    .scaledToFill()
            } placeholder: {
                Color.gray.opacity(0.2)
            }
            .frame(width: 80, height: 80)
            .clipShape(Circle())
                        
            VStack(spacing: 8) {
                Text(coffee.title)
                    .font(.system(size: 16, weight: .semibold))
                    .frame(maxWidth: .infinity, alignment: .leading)
                
                Text(coffee.description)
                    .font(.system(size: 14, weight: .regular))
                    .frame(maxWidth: .infinity, alignment: .leading)
            }
        }
        
        .padding(20)
    }
    
    var divider: some View {
        Color.gray.opacity(0.2)
            .frame(maxWidth: .infinity)
            .frame(height: 1)
    }
}

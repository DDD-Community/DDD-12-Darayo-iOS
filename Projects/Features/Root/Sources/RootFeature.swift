//
//  RootFeature.swift
//  Root
//
//  Created by 이정원 on 6/8/25.
//  Copyright © 2025 Darayo. All rights reserved.
//

import ComposableArchitecture
import Domain

@Reducer
public struct RootFeature {
    @Dependency(\.sampleUseCase) private var sampleUseCase
    
    @ObservableState
    public struct State {
        var isLoading: Bool = false
        var coffeeList: [Coffee] = []
        var errorMessage: String = ""
        public init() {}
    }
    
    public enum Action {
        case onAppear
        case coffeeListFetched([Coffee])
        case showError(Error)
    }
    
    public init() {}
    public var body: some ReducerOf<Self> {
        Reduce { state, action in
            switch action {
            case .onAppear:
                state.isLoading = true
                return .run { send in await send(fetchCoffeeList()) }
            case .coffeeListFetched(let coffeeList):
                state.coffeeList = coffeeList
                state.isLoading = false
                return .none
            case .showError(let error):
                state.errorMessage = error.localizedDescription
                state.isLoading = false
                return .none
            }
        }
    }
}

private extension RootFeature {
    func fetchCoffeeList() async -> Action {
        do {
            let coffeeList = try await sampleUseCase.fetchCoffeeList()
            return .coffeeListFetched(coffeeList)
        } catch {
            return .showError(error)
        }
    }
}

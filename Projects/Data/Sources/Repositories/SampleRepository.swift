//
//  SampleRepository.swift
//  Data
//
//  Created by 이정원 on 6/9/25.
//  Copyright © 2025 Darayo. All rights reserved.
//

import Domain
import Dependencies

public struct SampleRepository: SampleRepositoryProtocol {
    @Dependency(\.networkService) private var networkService
    
    public init() {}
    
    public func helloWorld() {
        print("Hello World!")
    }
}

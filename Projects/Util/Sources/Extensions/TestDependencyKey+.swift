//
//  TestDependencyKey+.swift
//  Util
//
//  Created by 이정원 on 6/9/25.
//  Copyright © 2025 Darayo. All rights reserved.
//

import Dependencies

public extension TestDependencyKey {
    static func unimplemented<T>(_ type: T.Type) -> Never {
        fatalError("\(type) is not implemented.")
    }
}

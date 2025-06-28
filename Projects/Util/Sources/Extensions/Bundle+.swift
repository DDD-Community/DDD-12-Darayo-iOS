//
//  Bundle+.swift
//  Util
//
//  Created by 이정원 on 6/28/25.
//  Copyright © 2025 Darayo. All rights reserved.
//

import Foundation

public extension Bundle {
    static let environment: String? = value(of: "Environment")
    
    private static func value(of key: String) -> String? {
        return Bundle.main.object(forInfoDictionaryKey: key) as? String
    }
}

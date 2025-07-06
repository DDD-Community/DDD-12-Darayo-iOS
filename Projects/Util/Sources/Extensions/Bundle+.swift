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
    static let appVersion = value(of: "CFBundleShortVersionString") ?? ""
    
    private static func value(of key: String) -> String? {
        return Bundle.main.object(forInfoDictionaryKey: key) as? String
    }
}

extension Bundle {
    func string(fileName: String) -> String? {
        let path = path(forResource: fileName, ofType: "txt")
        guard let path else { return nil }
        return try? String(contentsOfFile: path, encoding: .utf8)
    }
}

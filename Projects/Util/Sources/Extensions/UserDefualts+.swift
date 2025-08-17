//
//  UserDefualts+.swift
//  Util
//
//  Created by 이정원 on 8/17/25.
//  Copyright © 2025 Darayo. All rights reserved.
//

import Foundation

public extension UserDefaults {
    private enum Key {
        fileprivate static let festivalID = "festivalID"
    }
    
    static var festivalID: Int? {
        get {
            let id = Self.standard.integer(forKey: Key.festivalID)
            guard id != 0 else { return nil }
            return id
        }
        set { Self.standard.set(newValue, forKey: Key.festivalID) }
    }
}

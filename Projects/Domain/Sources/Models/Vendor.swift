//
//  Vendor.swift
//  Domain
//
//  Created by 이정원 on 6/30/25.
//  Copyright © 2025 Darayo. All rights reserved.
//

public enum Vendor {
    case yes24
    case melon
    
    public var name: String {
        switch self {
        case .yes24: "예스 24"
        case .melon: "멜론"
        }
    }
}

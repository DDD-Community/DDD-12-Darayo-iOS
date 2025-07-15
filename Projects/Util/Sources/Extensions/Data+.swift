//
//  Data+.swift
//  Util
//
//  Created by 이정원 on 7/14/25.
//  Copyright © 2025 Darayo. All rights reserved.
//

import Foundation

public extension Data {
    var toString: String {
        String(data: self, encoding: .utf8) ?? ""
    }
}

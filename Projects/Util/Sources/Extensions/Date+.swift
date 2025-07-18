//
//  Date+.swift
//  Util
//
//  Created by 이정원 on 7/15/25.
//  Copyright © 2025 Darayo. All rights reserved.
//

import Foundation

public extension Date {
    func toString(dateFormat: DateFormat) -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.locale = Locale(identifier: "ko_KR")
        dateFormatter.dateFormat = dateFormat.value
        return dateFormatter.string(from: self)
    }
}

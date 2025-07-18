//
//  Logger.swift
//  Util
//
//  Created by 이정원 on 7/18/25.
//  Copyright © 2025 Darayo. All rights reserved.
//

import OSLog

extension Logger {
    public func debug(_ message: String) {
        #if PROD && RELEASE
        return
        #else
        log(level: .debug, "\n🟢 \(message, privacy: .public)\n\n⠀")
        #endif
    }
    
    public func error(_ message: String) {
        #if PROD && RELEASE
        return
        #else
        log(level: .error, "\n🔴 \(message, privacy: .public)\n\n⠀")
        #endif
    }
}

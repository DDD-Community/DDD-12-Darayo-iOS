//
//  Logger+.swift
//  Network
//
//  Created by 이정원 on 7/18/25.
//  Copyright © 2025 Darayo. All rights reserved.
//

import OSLog
import Util
import Data
import Domain

extension Logger {
    private static let network = Logger(subsystem: Bundle.identifier, category: "Network")
    
    static func debug(request: URLRequest) {
        let logMessage = """
        [REQUEST]
        \(request.curlString)
        """
        network.debug(logMessage)
    }
    
    static func debug(path: String?, response: String?) {
        let logMessage = """
        [RESPONSE]
        PATH: \(path ?? "")
        \(response ?? "")
        """
        network.debug(logMessage)
    }
    
    static func error(_ error: NetworkError) {
        let logMessage = """
        [ERROR]
        TYPE: \(error.type)
        PATH: \(error.path ?? "")
        CODE: \(error.code?.string ?? "")
        MESSAGE: \(error.message ?? "")
        """
        network.error(logMessage)
    }
}

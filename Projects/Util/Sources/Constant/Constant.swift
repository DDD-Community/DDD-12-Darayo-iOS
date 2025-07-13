//
//  Constant.swift
//  Util
//
//  Created by 이정원 on 7/6/25.
//  Copyright © 2025 Darayo. All rights reserved.
//

import Foundation

public enum Constant {
    public enum URL {
        public static let base = ""
        public static let inquiry = "https://forms.gle/qm6g7U9FwKJkJgce8"
    }
    
    public enum Text {
        public static let termsOfService = Bundle.module.string(fileName: "TermsOfService") ?? ""
        public static let privacyPolicy = Bundle.module.string(fileName: "PrivacyPolicy") ?? ""
    }
}

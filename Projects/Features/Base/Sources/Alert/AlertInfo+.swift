//
//  AlertInfo+.swift
//  Base
//
//  Created by 이정원 on 8/22/25.
//  Copyright © 2025 Darayo. All rights reserved.
//

import SwiftUI
import DesignSystem

public extension AlertInfo {
    static var noInternet: Self {
        let message = """
        WIFI 또는 모바일 네트워크
        연결 상태를 확인해주세요.
        """
        
        return .init(
            icon: .iconError,
            title: "연결이 원활하지 않아요",
            message: message,
            buttonTitle: "확인"
        )
    }
    
    static var error: Self {
        let message = """
        일시적인 오류가 발생했어요. 
        """
        
        return .init(
            icon: .iconError,
            title: "잠시 오류가 발생했어요",
            message: message,
            buttonTitle: "확인"
        )
    }
    
    static var authorization: Self {
        return .init(
            icon: Image.iconBellGray,
            title: "알림 권한이 없어요",
            box: .init(
                upperText: "권한을 허용하면",
                highlightText: "좋아요한 페스티벌 예매일, 반입규정, 교통안내",
                lowerText: "알림을 PUSH로 보내드려요."
            ),
            hasCloseButton: true,
            buttonTitle: "권한 허용하기"
        )
    }
    
    static var agreement: Self {
        return .init(
            icon: Image.iconBellGray,
            title: "알림 수신 동의가 필요해요",
            box: .init(
                upperText: "수신에 동의하면",
                highlightText: "좋아요한 페스티벌 예매일, 반입규정, 교통안내",
                lowerText: "알림을 PUSH로 보내드려요."
            ),
            hasCloseButton: true,
            buttonTitle: "수신 동의하기"
        )
    }
}

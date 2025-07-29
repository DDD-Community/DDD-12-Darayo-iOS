//
//  Vendor.swift
//  Domain
//
//  Created by 이정원 on 6/30/25.
//  Copyright © 2025 Darayo. All rights reserved.
//

public struct Vendor {
    public let name: String
    public let urlString: String
    
    public init(urlString: String) {
        self.name = VendorType(urlString: urlString)?.name ?? ""
        self.urlString = urlString
    }
}

public enum VendorType: CaseIterable {
    case ticketlink
    case melon
    case yes24
    case interpark
    case wemakeprice
    case naver
    case coupang
    case kream
    case musinsa
    case twentyninecm
    case ssfshop
    case tenbyten
    case wigglewiggle
    case hiver
    case others
    
    init?(urlString: String?) {
        guard let urlString else { return nil }
        let type = Self.allCases.first { urlString.contains($0.domainKeyword) }
        guard let type else { return nil }
        self = type
    }
    
    var domainKeyword: String {
        switch self {
        case .ticketlink: "ticketlink.co"
        case .melon: "melon.co"
        case .yes24: "yes24.co"
        case .interpark: "interpark.co"
        case .wemakeprice: "wemakeprice.co"
        case .naver: "naver.co"
        case .coupang: "couapngplay.co"
        case .kream: "kream.co"
        case .musinsa: "musinsa.co"
        case .twentyninecm: "29cm.co"
        case .ssfshop: "ssfshop.co"
        case .tenbyten: "10x10.co"
        case .wigglewiggle: "wiggle-wiggle.co"
        case .hiver: "hiver.co"
        case .others: "."
        }
    }
    
    public var name: String {
        switch self {
        case .ticketlink: "티켓링크"
        case .melon: "멜론티켓"
        case .yes24: "예스24티켓"
        case .interpark: "인터파크티켓"
        case .wemakeprice: "위메프"
        case .naver: "네이버"
        case .coupang: "쿠팡"
        case .kream: "크림"
        case .musinsa: "무신사"
        case .twentyninecm: "29CM"
        case .ssfshop: "SSF샵"
        case .tenbyten: "텐바이텐"
        case .wigglewiggle: "위글위글"
        case .hiver: "하이버"
        case .others: "기타"
        }
    }
}

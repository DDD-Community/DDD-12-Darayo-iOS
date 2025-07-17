//
//  ResponseWrapper.swift
//  Data
//
//  Created by 이정원 on 7/14/25.
//  Copyright © 2025 Darayo. All rights reserved.
//

public struct ResponseWrapper<T: Decodable>: Decodable {
    public let resultCode: String?
    public let resultMsg: String?
    public let error: String?
    public let result: T?
}

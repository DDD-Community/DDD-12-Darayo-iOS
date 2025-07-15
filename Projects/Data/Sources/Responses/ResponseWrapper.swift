//
//  ResponseWrapper.swift
//  Data
//
//  Created by 이정원 on 7/14/25.
//  Copyright © 2025 Darayo. All rights reserved.
//

struct ResponseWrapper<T: Decodable>: Decodable {
    let resultCode: String?
    let resultMsg: String?
    let result: T?
}

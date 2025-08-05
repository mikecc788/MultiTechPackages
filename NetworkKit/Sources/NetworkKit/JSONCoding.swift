//
//  File.swift
//  MultiTechPackages
//
//  Created by app on 2025/8/5.
//

import Foundation

public struct JSONCoder {
    public static let decoder: JSONDecoder = {
        let d = JSONDecoder()
        d.dateDecodingStrategy = .iso8601
        return d
    }()
    public static let encoder: JSONEncoder = {
        let e = JSONEncoder()
        e.dateEncodingStrategy = .iso8601
        return e
    }()
}

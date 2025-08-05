//
//  File.swift
//  MultiTechPackages
//
//  Created by app on 2025/8/5.
//

import Foundation

public protocol Endpoint {
    associatedtype Response: Decodable
    var urlRequest: URLRequest { get }
}

public enum APIError: Error, Sendable {
    case invalidResponse(status: Int)
    case decoding(Error)
    case underlying(Error)
}

//
//  File.swift
//  MultiTechPackages
//
//  Created by app on 2025/8/5.
//

import Foundation

public struct HTTPClient: Sendable {
    private let session: URLSession
    public init(configuration: URLSessionConfiguration = .ephemeral) {
        self.session = URLSession(configuration: configuration)
    }

    public func send<E: Endpoint>(_ endpoint: E) async throws -> E.Response {
        do {
            let (data, resp) = try await session.data(for: endpoint.urlRequest)
            guard let http = resp as? HTTPURLResponse, 200..<300 ~= http.statusCode else {
                throw APIError.invalidResponse(status: (resp as? HTTPURLResponse)?.statusCode ?? -1)
            }
            do {
                return try JSONCoder.decoder.decode(E.Response.self, from: data)
            } catch {
                throw APIError.decoding(error)
            }
        } catch {
            throw APIError.underlying(error)
        }
    }
}

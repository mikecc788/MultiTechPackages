//
//  File.swift
//  MultiTechPackages
//
//  Created by app on 2025/8/5.
//

import XCTest
@testable import NetworkKit

private struct Todo: Decodable { let id: Int; let title: String }
private struct GetTodo: Endpoint {
    typealias Response = Todo
    var urlRequest: URLRequest {
        URLRequest(url: URL(string: "https://jsonplaceholder.typicode.com/todos/1")!)
    }
}

final class NetworkKitTests: XCTestCase {
    func testSend() async throws {
        let client = HTTPClient()
        let todo: Todo = try await client.send(GetTodo())
        XCTAssertEqual(todo.id, 1)
    }
}

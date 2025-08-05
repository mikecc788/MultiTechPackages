//
//  File.swift
//  MultiTechPackages
//
//  Created by app on 2025/8/5.
//

import Foundation

public protocol BLECentral: Sendable {
    var stateStream: AsyncStream<CentralState> { get }
    func scan(filter: ScanFilter) -> AsyncStream<ScanResult>
    func connect(to peripheralID: UUID, timeout: TimeInterval?) async throws -> BLEConnection
}

public protocol BLEConnection: Sendable {
    var peripheralID: UUID { get }
    var isConnected: Bool { get }
    func discover(services: [UUID]?) async throws -> [ServiceInfo]
    func read(_ characteristic: CharacteristicID) async throws -> Data
    func write(_ characteristic: CharacteristicID, data: Data, mode: WriteMode) async throws
    func notifications(_ characteristic: CharacteristicID) -> AsyncStream<Data>
    func disconnect() async
}

public enum BLEError: Error, Sendable {
    case notPoweredOn
    case unauthorized
    case notFound
    case timeout
    case characteristicNotFound
    case disconnected
    case underlying(String)
}

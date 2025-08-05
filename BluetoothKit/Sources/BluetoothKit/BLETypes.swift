//
//  File.swift
//  MultiTechPackages
//
//  Created by app on 2025/8/5.
//

import Foundation

public enum CentralState: Equatable, Sendable {
    case unknown, resetting, unsupported, unauthorized, poweredOff, poweredOn
}

public struct ScanFilter: Sendable {
    public var services: [UUID] = []
    public var allowDuplicates: Bool = false
    public init(services: [UUID] = [], allowDuplicates: Bool = false) {
        self.services = services
        self.allowDuplicates = allowDuplicates
    }
}

public struct ScanResult: Sendable {
    public let peripheralID: UUID
    public let name: String?
    public let rssi: Int
    public let advertisedServices: [UUID]
    public init(peripheralID: UUID, name: String?, rssi: Int, advertisedServices: [UUID]) {
        self.peripheralID = peripheralID
        self.name = name
        self.rssi = rssi
        self.advertisedServices = advertisedServices
    }
}

public enum WriteMode { case withResponse, withoutResponse }

public struct ServiceInfo: Sendable {
    public let uuid: UUID
    public let characteristics: [CharacteristicInfo]
    public init(uuid: UUID, characteristics: [CharacteristicInfo]) {
        self.uuid = uuid
        self.characteristics = characteristics
    }
}

public struct CharacteristicInfo: Sendable {
    public let uuid: UUID
    public let properties: Set<String> // 简化：读/写/通知
    public init(uuid: UUID, properties: Set<String>) {
        self.uuid = uuid
        self.properties = properties
    }
}

public struct CharacteristicID: Hashable, Sendable {
    public let service: UUID
    public let characteristic: UUID
    public init(service: UUID, characteristic: UUID) {
        self.service = service
        self.characteristic = characteristic
    }
}

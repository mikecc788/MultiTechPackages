//
//  File.swift
//  MultiTechPackages
//
//  Created by app on 2025/8/5.
//

import Foundation

public final class FakeCentral: BLECentral {
    public init() {}

    public var stateStream: AsyncStream<CentralState> {
        AsyncStream { c in
            c.yield(.poweredOn)
        }
    }

    public func scan(filter: ScanFilter) -> AsyncStream<ScanResult> {
        AsyncStream { c in
            Task {
                try? await Task.sleep(nanoseconds: 300_000_000)
                c.yield(ScanResult(peripheralID: UUID(), name: "Demo Device", rssi: -48, advertisedServices: []))
                c.finish()
            }
        }
    }

    public func connect(to peripheralID: UUID, timeout: TimeInterval?) async throws -> BLEConnection {
        return FakeConnection(peripheralID: peripheralID)
    }

    private final class FakeConnection: BLEConnection ,@unchecked Sendable{
        let peripheralID: UUID
        var isConnected: Bool = true
        init(peripheralID: UUID) { self.peripheralID = peripheralID }

        func discover(services: [UUID]?) async throws -> [ServiceInfo] {
            [ServiceInfo(uuid: UUID(), characteristics: [CharacteristicInfo(uuid: UUID(), properties: ["read","write"])])]
        }

        func read(_ characteristic: CharacteristicID) async throws -> Data { Data([0x2A]) }

        func write(_ characteristic: CharacteristicID, data: Data, mode: WriteMode) async throws {}

        func notifications(_ characteristic: CharacteristicID) -> AsyncStream<Data> {
            AsyncStream { c in
                Task {
                    for i in 0..<3 {
                        try? await Task.sleep(nanoseconds: 200_000_000)
                        c.yield(Data([UInt8(i)]))
                    }
                    c.finish()
                }
            }
        }

        func disconnect() async { isConnected = false }
    }
}

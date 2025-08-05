//
//  File.swift
//  MultiTechPackages
//
//  Created by app on 2025/8/5.
//

import XCTest
@testable import BluetoothKit

final class BluetoothKitTests: XCTestCase {
    func testFakeScanConnect() async throws {
        let central: BLECentral = FakeCentral()
        var gotDevice: ScanResult?
        for await d in central.scan(filter: .init()) {
            gotDevice = d
        }
        XCTAssertNotNil(gotDevice)
        if let id = gotDevice?.peripheralID {
            let conn = try await central.connect(to: id, timeout: 2)
            let services = try await conn.discover(services: nil)
            XCTAssertFalse(services.isEmpty)
        }
    }
}

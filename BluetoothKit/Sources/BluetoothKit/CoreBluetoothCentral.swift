//
//  File.swift
//  MultiTechPackages
//
//  Created by app on 2025/8/5.
//

#if canImport(CoreBluetooth)
import CoreBluetooth
import Foundation

public final class CoreBluetoothCentral: NSObject, @unchecked Sendable {
    private let queue = DispatchQueue(label: "bt.core.central")
    private var central: CBCentralManager!
    private var stateContinuation: AsyncStream<CentralState>.Continuation?
    private var stateSubject: AsyncStream<CentralState>!

    public override init() {
        super.init()
        var cont: AsyncStream<CentralState>.Continuation!
        let stream = AsyncStream<CentralState> { c in
            cont = c
        }
        self.stateSubject = stream
        self.stateContinuation = cont
        self.central = CBCentralManager(delegate: self, queue: queue)
    }
}

extension CoreBluetoothCentral: BLECentral {
    public var stateStream: AsyncStream<CentralState> { stateSubject }

    public func scan(filter: ScanFilter) -> AsyncStream<ScanResult> {
        AsyncStream { continuation in
            queue.async {
                guard self.central.state == .poweredOn else {
                    continuation.finish()
                    return
                }
                let services = filter.services.map { CBUUID(nsuuid: $0 as NSUUID as UUID) }
                self.central.scanForPeripherals(
                    withServices: services.isEmpty ? nil : services,
                    options: [CBCentralManagerScanOptionAllowDuplicatesKey: filter.allowDuplicates]
                )
            }
            // NOTE: 实际应在 didDiscover 回调里 continuation.yield(...)
        }
    }

    public func connect(to peripheralID: UUID, timeout: TimeInterval?) async throws -> BLEConnection {
        // TODO: 查询已发现或已连接的 CBPeripheral，发起连接，等待回调。此处给出简化占位：
        throw BLEError.underlying("connect() not implemented yet")
    }
}

extension CoreBluetoothCentral: CBCentralManagerDelegate {
    public func centralManagerDidUpdateState(_ central: CBCentralManager) {
        let mapped: CentralState
        switch central.state {
        case .unknown:     mapped = .unknown
        case .resetting:   mapped = .resetting
        case .unsupported: mapped = .unsupported
        case .unauthorized:mapped = .unauthorized
        case .poweredOff:  mapped = .poweredOff
        case .poweredOn:   mapped = .poweredOn
        @unknown default:  mapped = .unknown
        }
        stateContinuation?.yield(mapped)
    }

    public func centralManager(_ central: CBCentralManager,
                               didDiscover peripheral: CBPeripheral,
                               advertisementData: [String : Any],
                               rssi RSSI: NSNumber) {
        // TODO: 通过某个扫描流的 continuation 输出 ScanResult
    }
}
#endif

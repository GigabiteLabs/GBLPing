// GBLPing.swift
//
// Created by GigabiteLabs on 4/14/20
// Swift Version: 5.0
// Copyright © 2020 GigabiteLabs. All rights reserved.
//

import Foundation

/// The main interface into GBLPing. Initializes a shared instance of the GBLPingService.
public struct GBLPing {
    /// A shared instance of GBLPing to be used
    /// or shared among multiple views or objects.
    ///
    /// - Note: This shared instance retains values
    /// in between usage. So long as it is not deallocated,
    /// the data from a prior ping session will be available
    /// to another object without having to invoke another
    /// ping session.
    ///
    public static let svc = GBLPingService()
    /// LocalDevice-relate operations, attributes and values.
    public static var localDevice: GBLPingLocalDevice {
        return GBLPingLocalDevice()
    }
    /// Network-related operations, attributes, and values.
    public static var network: GBLPingNetwork {
        return GBLPingNetwork()
    }
    /// Operations and values related to known DNS network hosts.
    public static var host: GBLPingHost {
        return GBLPingHost()
    }
    /// Restrict init to within framework
    private init() { }
}

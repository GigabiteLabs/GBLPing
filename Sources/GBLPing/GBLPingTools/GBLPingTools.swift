// GBLPingTools.swift
//
// Created by GigabiteLabs on 9/29/20
// Swift Version: 5.0
// Copyright © 2020 GigabiteLabs. All rights reserved.
//

import Foundation

/// A typealias `GBLPingTools`for more convenient use.
public typealias PingTools = GBLPingTools
/// A suite of tools for use in gathering information & metrics
/// about HTTP, IP, and other network connectivity on-device.
public final class GBLPingTools {
    // initializable only by the
    // framework
    internal init() { }
    /// Local device information & metrices
    public var device: GBLPingLocalDevice {
        get {
            return GBLPingLocalDevice()
        }
    }
    /// Internet connectivity information and metrics
    public var internet: GBLPingInternet {
        get {
            return GBLPingInternet()
        }
    }
    /// HTTP host connectivity, information,
    /// and metrics.
    public var host: GBLPingHost {
        get {
            return GBLPingHost()
        }
    }
}

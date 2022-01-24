// File.swift
//
// Created by GigabiteLabs on 10/1/20
// Swift Version: 5.0
// Copyright © 2020 GigabiteLabs. All rights reserved.
//

import Foundation
import XCTest

/// A collection of utilities  and convenience
/// functions pertaining to network operations.
public struct GBLPingNetwork {
    /// Checks if an internet connection is active.
    /// - Parameters:
    ///     - closure: a `((Bool) -> Void?)` closure invoked when the operation completes
    ///
    public func isReachable(_ completion: ((Bool) -> Void)?) {
        // setup completion
        Ping.svc.cache.reachabilityCompletion = completion
        // ping it
        Ping.svc.pingHostname (
            hostname: Ping.svc.cache.defaultPingHost,
            maxPings: 1) { result in
                Ping.svc.cache.reachabilityCompletion?(result)
            }
    }
}

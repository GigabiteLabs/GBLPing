// File.swift
//
// Created by GigabiteLabs on 9/30/20
// Swift Version: 5.0
// Copyright © 2020 GigabiteLabs. All rights reserved.
//

import Foundation

/// A collection of utilities  and convenience
/// functions pertaining to hostname & DNS operations.
public struct GBLPingHost {
    /// Checks if a given hostname is reachable.
    /// - Parameters:
    ///     - hostname:  a `String` representing the textual hostname
    ///     - closure: a `((Bool) -> Void?)` closure invoked when the operation completes
    public func isReachable(hostname: String, _ completion: ((Bool) -> Void)?) {
        // setup completion
        Ping.svc.cache.reachabilityCompletion = completion
        // ping it
        Ping.svc.pingHostname(
            hostname: hostname,
            maxPings: 1) { result in
                Ping.svc.cache.reachabilityCompletion?(result)
            }
    }
}

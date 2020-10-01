// File.swift
//
// Created by GigabiteLabs on 9/30/20
// Swift Version: 5.0
// Copyright © 2020 GigabiteLabs. All rights reserved.
//

import Foundation

/// A typealias `GBLPingHost`for more convenient use.
public typealias PingHost = GBLPingHost
/// An object representation of measurable attributes
/// & utilities pertaining to HTTP hosts.
public final class GBLPingHost: GBLHTTPEntity {
    /// Checks if an internet connection is active
    ///
    /// - Returns:
    ///     - `(Bool) -> Void`, a closure with a boolean value indicating if the internet is reachable
    ///
    public func reachable(_ hostname: String, completion: @escaping (Bool) -> Void) {
        reachable(hostName: hostname) { (status) in
            completion(status)
        }
    }
}

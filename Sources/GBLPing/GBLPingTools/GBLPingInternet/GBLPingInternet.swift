// File.swift
//
// Created by GigabiteLabs on 10/1/20
// Swift Version: 5.0
// Copyright © 2020 GigabiteLabs. All rights reserved.
//

import Foundation

/// A typealias `GBLPingInternet`for more convenient use.
public typealias internet = GBLPingInternet
/// An object representation of measurable attributes
/// & utilities pertaining to the Internet.
public final class GBLPingInternet: GBLHTTPEntity {
    /// Checks if an internet connection is active
    ///
    /// - Returns:
    ///     - `(Bool) -> Void`, a closure with a boolean value indicating if the internet is reachable
    ///
    public func reachable(completion: @escaping (Bool) -> Void) {
        reachable(hostName: nil) { (status) in
            completion(status)
        }
    }
}

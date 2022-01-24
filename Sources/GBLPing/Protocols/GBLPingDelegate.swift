// GBLPingDelegate.swift
//
// Created by GigabiteLabs on 4/14/20
// Swift Version: 5.0
// Copyright © 2020 GigabiteLabs. All rights reserved.
//

import Foundation

/// Conforming objects will recieve messages from GBLPing for all service events.
@objc public protocol GBLPingDelegate: AnyObject {
    /// Called after a ping event completes to provide
    /// the `GBLPingDataDelegate` with a
    /// `GBLPingResult` object created during a ping event.
    ///
    /// - Parameters:
    ///     - result: `GBLPingResult` an object that
    ///     resulted from a successful ping event. This object
    ///     contains metadata about the ping event and it's
    ///     relative position within the ping event sequence.
    ///
    /// - Note: Use error.rawValue to retrieve the error description
    /// string with more detailed error information.
    ///
    /// - Seealso: `GBLPingResult.swift`
    ///
    func gblPingResult(result: GBLPingResult)
    /// Called when an error occurs during a ping service event is in progress,
    /// or while the service is being configured or deallocated.
    /// Can be called for usage & config errors, as well as ping errors.
    ///
    /// - Parameters:
    ///     - error: `GBLPingUnexpectedEvent` that describes
    ///     the explicit type error that occured.
    ///
    /// - Note: Use error.rawValue to retrieve the error description
    /// string with more detailed error information.
    ///
    func gblPingError(_ error: GBLPingUnexpectedEvent)
}

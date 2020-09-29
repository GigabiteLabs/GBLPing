// GBLPingDelegate.swift
//
// Created by GigabiteLabs on 4/14/20
// Swift Version: 5.0
// Copyright © 2020 GigabiteLabs. All rights reserved.
//

import Foundation

/// Conforming objects will recieve messages from GBLPing for all service events.
@objc public protocol GBLPingDelegate {
    /// Called when a normal `GBLPingService` event occurs. (e.g. not
    /// an error or unexpected event.
    ///
    /// - Parameters:
    ///     - event: a `GBLPingEvent` object ecapsulating the
    ///     attributes of the actual ping operation
    ///
    func gblPingEvent(_ event: GBLPingEvent)
    /// Called when an unexpected event occurs
    ///
    /// - Parameters:
    ///     - type: a `GBLPingUnexpectedEvent` object describing the type of
    ///     unexpected event that occured.
    ///
    /// - Note: Get the event description by accessing the .description property from
    ///  the returned value.
    ///
    ///  Example:
    ///
    ///     ```swift
    ///     let msg: String = type.description
    ///     print("unexpected event msg: \(msg)")
    ///     ```
    ///
    /// Unexpected events are not necessarily failures, weird stuff sometimes happens with packets during transport.
    /// That being said, an unexpected event is a good time to run some logic to handle these edge cases.
    ///
    func gblPingUnexpected(event: GBLPingUnexpectedEvent)
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

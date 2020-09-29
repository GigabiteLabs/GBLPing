// GBLPingDelegate.swift
//
// Created by GigabiteLabs on 4/14/20
// Swift Version: 5.0
// Copyright © 2020 GigabiteLabs. All rights reserved.
//

import Foundation

/// Conforming objects will recieve messages from GBLPing for all service events.
public protocol GBLPingDelegate {
    /// Called when either a success or an unexpected event occured
    ///
    /// - Parameters:
    ///     - event: a `GBLPingEvent` object ecapsulating the
    ///     attributes of the actual ping operation
    ///     - description: a `String` description of the event
    ///     - unexpectedEventType: an optional `GBLPingUnexpectedEvent`
    ///     object that, if returned, serves as a flag and desriptor to the consuming
    ///     application that something unexpected occured, and what it was.
    ///
    /// - Note: Unexpected events are not necessarily failures, weird stuff sometimes happens with packets during transport.
    /// That being said, an unexpected event is a good time to run some logic to handle these edge cases
    func pingEventOccured(event: GBLPingEvent, description: String, unexpectedEventType: GBLPingUnexpectedEvent?)
    /// Called when an error occurs. Can be called for usage & Config
    /// errors, as well as Ping errors.
    ///
    /// - Parameters:
    ///     - error: `GBLPingUnexpectedEvent` that describes
    ///     the type of error that occured.
    ///
    /// - Note: Use error.rawValue to retrieve the error description
    /// string with more detailed error information.
    ///
    func pingError(error: GBLPingUnexpectedEvent)
}

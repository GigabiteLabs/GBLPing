// GBLPingEvent.swift
//
// Created by GigabiteLabs on 4/14/20
// Swift Version: 5.0
// Copyright © 2020 GigabiteLabs. All rights reserved.
//

import Foundation

/// An enum representing all of the known & supported event outcomes resulting from an attempt to ping.
@objc public enum GBLPingEvent: Int, Codable {
    // TODO: Evaluate these
    case debugMessage, infoMessage
    // Lifecycle events
    case pingReadyToStart
    case pingWillStart
    case pingDidStart
    case pingDidStop
    case pingMaximumReached
    // Expirations
    case pingTimeExpired
    case maxPingsReached
    // Outcomes
    case responsePacketRecieved
    case packetSent
    case pingFailure
    case unexpectedPacketRecieved
    case unexpectedEvent
    /// A case indicating the default state when
    /// retrieved from a `GBLPingResult` object.
    ///
    /// - Note: This essentially means that
    /// no actual event occured yet, the object was
    /// just initialized.
    ///
    /// File a bug report if this is passed to your delegate.
    ///
    case resultInitialized
}

// GBLPingEvent.swift
//
// Created by GigabiteLabs on 4/14/20
// Swift Version: 5.0
// Copyright © 2020 GigabiteLabs. All rights reserved.
//

import Foundation

/// An enum representing all of the known & supported event outcomes resulting from an attempt to ping.
@objc public enum GBLPingEvent: Int, Codable {
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
    /// A string description of the event.
    public var description: String {
        switch self {
        // Lifecycle events
        case .pingReadyToStart:
            return "pingReadyToStart"
        case .pingWillStart:
            return "pingWillStart"
        case .pingDidStart:
            return "pingDidStart"
        case .pingDidStop:
            return "pingDidStop"
        case .pingMaximumReached:
            return "pingMaximumReached"
        // Expirations
        case .pingTimeExpired:
            return "pingTimeExpired"
        case .maxPingsReached:
            return "maxPingsReached"
        // Outcomes
        case .responsePacketRecieved:
            return "responsePacketRecieved"
        case .packetSent:
            return "packetSent"
        case .pingFailure:
            return "pingFailure"
        case .unexpectedPacketRecieved:
            return "unexpectedPacketRecieved"
        case .unexpectedEvent:
            return "unexpectedEvent"
        case .resultInitialized:
            return "resultInitialized"
        }
    }
}

// GBLPingEvent.swift
//
// Created by GigabiteLabs on 4/14/20
// Swift Version: 5.0
// Copyright © 2020 GigabiteLabs. All rights reserved.
//

import Foundation

/// An enum representing all of the known & supported event outcomes resulting from an attempt to ping.
@objc public enum GBLPingEvent: Int, Codable {
    // Ping Service Lifecycle
    /// An event indicating that the ping service is ready to start.
    case pingReadyToStart
    /// An event indicating that the ping service is about to start.
    case pingWillStart
    /// An event indicating that the ping service did already start.
    case pingDidStart
    /// An event indicating that the ping service stopped.
    case pingDidStop
    // Ping Service Expirations
    /// An event indicating that a maximum number of ping attempts has been reached.
    case pingMaximumReached
    /// An event indicating that the ping service has reached the maximum amount of time configured.
    case pingTimeExpired
    // Ping Event Outcomes
    /// An event indicating that a valid response packet was recieved from the ping target host.
    case responsePacketRecieved
    /// An event indicating that a packet has been sent by the ping service to the ping target host.
    case packetSent
    /// An event indicating that an attempt to ping a targeted host has failed.
    case pingFailure
    /// An event indicating that a packet has been recieved from the targeted host that did not match expectations.
    case unexpectedPacketRecieved
    /// An event indicating that some unexpected event has occured while attempting to ping a taret host.
    case unexpectedEvent
    /// A case indicating the default state when
    /// retrieved from a `GBLPingResult` object.
    ///
    /// - Note: This essentially means that
    /// no actual event occured yet, the object was
    /// just initialized.
    ///
    /// File a bug report if this is passed to your delegate.
    case resultInitialized
    /// A string description of the event.
    public var description: String {
        switch self {
        // Ping Service Lifecycle events
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
        // Ping Service Expirations
        case .pingTimeExpired:
            return "pingTimeExpired"
        // Ping Service Outcomes
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

// GBLPingEvent.swift
//
// Created by GigabiteLabs on 4/14/20
// Swift Version: 5.0
// Copyright © 2020 GigabiteLabs. All rights reserved.
//

import Foundation

/// An enum representing all of the known & supported event outcomes resulting from an attempt to ping.
public enum GBLPingEvent: String, CaseIterable{
    // Messages
    case debugMessage, infoMessage
    // Lifecycle events
    case pingWillStart, pingDidStart, pingDidStop
    // Outcomes
    case packetRecieved, packetSent, pingFailure, unexpectedEvent
}

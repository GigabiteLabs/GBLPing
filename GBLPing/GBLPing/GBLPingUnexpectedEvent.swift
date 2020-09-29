// GBLPingUnexpectedEvent.swift
//
// Created by GigabiteLabs on 4/14/20
// Swift Version: 5.0
// Copyright © 2020 GigabiteLabs. All rights reserved.
//

import Foundation

/// An enum representing the known & unexpected events that could occur
public enum GBLPingUnexpectedEvent: String, CaseIterable, Codable {
    // Network related issues
    // TODO: Consider expanding this
    case packetDiscrepancy = "There was a difference between what was expected during the ping event and what occured."
    // Usage & Configuration related issues
    case invalidUsage = "An error occured, this is an invalid use of the service"
    case bothIPVersionsSpecified = "both ipv4 and ipv6 was specified, only one or the other is supported."
    case noIPVersionsSpecified = "usage of this function requires an argument for either ipv4 or ipv6. both cannot be nil."
    case noHostName = "no hostname was provided."
    case maxPingsInvalid = "The value set for max pings was invalid. Try another value greater than zero."
    case invalidHostname = "an invalid hostname was provided."
    // Catch-alls
    case internalError = "An internal framework error occured. Please report this as a bug."
    case unkownError = "An unknown error occured. Please report this as a bug."
}

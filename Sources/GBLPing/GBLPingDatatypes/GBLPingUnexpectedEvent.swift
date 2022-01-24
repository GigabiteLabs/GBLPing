// GBLPingUnexpectedEvent.swift
//
// Created by GigabiteLabs on 4/14/20
// Swift Version: 5.0
// Copyright © 2020 GigabiteLabs. All rights reserved.
//

import Foundation

/// An enum representing the known & unexpected events that could occur
@objc public enum GBLPingUnexpectedEvent: Int, Codable {
    // Network related issues
    // TODO: Add documentation
    case packetDiscrepancy
    case failedToSendPacket
    // Usage & Configuration related issues
    case invalidUsage
    case bothIPVersionsSpecified
    case noIPVersionsSpecified
    case noHostName
    case maxPingsInvalid
    case timeLimitInvalid
    case invalidHostname
    // Other Errors
    case internalError
    case unkownError
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
        case .packetDiscrepancy:
            return "there was a difference between what was expected during the ping event and what occured."
        case .failedToSendPacket:
            return "the attemmpt to send the packet failed and was not sent."
        // Usage & Configuration related issues
        case .invalidUsage:
            return "tn error occured due to an invalid use of the service"
        case .bothIPVersionsSpecified:
            return "both ipv4 and ipv6 was specified, only one or the other is supported."
        case .noIPVersionsSpecified:
            return "usage of this function requires an argument for either ipv4 or ipv6. both cannot be nil."
        case .noHostName:
            return "no hostname was provided."
        case .maxPingsInvalid:
            return "the value set for max pings was invalid. Try another value greater than zero."
        case .timeLimitInvalid:
            return "the time limit configuration was invalid. Try another value greater than one second."
        case .invalidHostname:
            return "an invalid hostname was provided."
        // Catch-alls
        case .internalError:
            return "an internal framework error occured. Please report this as a bug."
        case .unkownError:
            return "an unknown error occured. please report this as a bug."
        case .resultInitialized:
            return "this is in internal configuration issue, this should never ordinarily be passed to a consuming application."
        }
    }
}

// GBLPingUnexpectedEvent.swift
//
// Created by GigabiteLabs on 4/14/20
// Swift Version: 5.0
// Copyright © 2020 GigabiteLabs. All rights reserved.
//

import Foundation

/// An enum representing the known & unexpected events that could occur
public enum GBLPingUnexpectedEvent: String, CaseIterable {
    // Network related issues
    case packetDiscrepancy
    // Usage related issues
    case invalidUsage
    // Catch-alls
    case internalError, unkownError
}

// GBLPingService+MaxPings.swift
//
// Created by GigabiteLabs on 9/29/20
// Swift Version: 5.0
// Copyright © 2020 GigabiteLabs. All rights reserved.
//

import Foundation

internal extension GBLPingService {
    /// Handles internal checking if a maximum
    /// configured attempts has been reached
    func checkIfMaxPingsReached() {
        // ensure a max was set, or just return
        guard let max = cache.maxPings else {
            return
        }
        // get the current number of attempts
        let attempts = incrementAttempts()
        // compare and stop if we've reached the max
        if attempts == max {
            // schedule service stoppage
            cache.stopScheduled = true
            // update state
            lastPingEventType = .pingMaximumReached
        }
    }
    /// Handles safe incrementation and retrieval of the number
    /// of attempts for the current ping operation.
    ///
    /// - Returns: `Int`, representing the number of attempted pings
    /// for the current operation after incrementation.
    ///
    /// - Note: The function handles the case a ping operation has never been
    /// attempted and will always return a number greater than or equal to 1.
    func incrementAttempts() -> Int {
        if var attempts: Int = cache.pingAttempts, attempts > 0 {
            attempts += 1
            cache.pingAttempts = attempts
            return attempts
        } else {
            cache.pingAttempts = 1
            return 1
        }
    }
    /// Checks if the ping service has been flagged to stop and stops it, if so.
    func checkIfStopScheduled() {
        // stop the service if scheduled
        if cache.stopScheduled {
            stop()
        }
    }
}

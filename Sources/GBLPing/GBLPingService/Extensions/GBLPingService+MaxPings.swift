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
        #if DEBUG
        print("Internal: \(#function)")
        #endif

        print("max pingconfig: \(cache.maxPings ?? 0)")
        // ensure a max was set, or just return
        guard let max = cache.maxPings else {
            #if DEBUG
            print("no max set")
            #endif
            return
        }
        // get the current number of attempts
        let attempts = incrementAttempts()
        #if DEBUG
        print("number of attempts: \(attempts)")
        #endif
        // compare and stop if we've reached the max
        if attempts == max {
            cache.stopScheduled = true
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

    func checkIfStopScheduled() {
        // stop the service if scheduled
        if cache.stopScheduled {
            stop()
        }
    }
}

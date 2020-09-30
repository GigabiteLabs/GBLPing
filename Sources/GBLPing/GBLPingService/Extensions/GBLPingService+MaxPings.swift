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
    func checkIfMaxPingsReached(){
        print("Internal: \(#function)")
        // ensure a max was set, or just return
        guard let max = maxPings else {
            print("no max set")
            return
        }
        // get the current number of attempts
        let attempts = incrementAttempts()
        print("number of attempts: \(attempts)")
        // compare and stop if we've reached the max
        if attempts == max {
            stopScheduled = true
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
        if var attempts: Int = pingAttempts, attempts > 0 {
            attempts += 1
            pingAttempts = attempts
            return attempts
        } else {
            pingAttempts = 1
            return 1
        }
    }
    
    func checkIfStopScheduled() {
        // stop the service if scheduled
        if stopScheduled {
            stop()
        }
    }
}

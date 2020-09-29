// GBLPingService+PingFunctions.swift
//
// Created by GigabiteLabs on 9/29/20
// Swift Version: 5.0
// Copyright © 2020 GigabiteLabs. All rights reserved.
//

import Foundation

extension GBLPingService {
    /// Stops the ping service
    internal func stop() {
        pinger?.stop()
        pinger = nil
        pingerDidStop()
        maxPings = nil
        pingAttempts = nil
    }
    /// Resets the result object for a new operation
    internal func reset(for host: String){
        // setup / reset the result type for current service operation
        lastPingEventType = .pingReadyToStart
        // setup new squence ID
        self.currentSequenceID = UUID().uuidString
    }
}

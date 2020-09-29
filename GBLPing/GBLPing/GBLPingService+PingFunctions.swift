// GBLPingService+PingFunctions.swift
//
// Created by GigabiteLabs on 9/29/20
// Swift Version: 5.0
// Copyright © 2020 GigabiteLabs. All rights reserved.
//

import Foundation

/// An extension for `GBLPingService` with internal
/// controlling functions for ping events.
extension GBLPingService {
    /// Resets the  all variables from any previous ping events,
    /// sets up the service to restart, and reconfigures the`GBLPingService`
    /// for a new ping event.
    ///
    /// - Parameters:
    ///     - host: the string hostname at which the next ping
    ///     service events will be targeted.
    ///
    internal func startPinging(_ hostname: String){
        resetPingEventVars()
        // setup / reset the result type for current service operation
        lastPingEventType = .pingReadyToStart
        // setup new squence ID
        self.currentSequenceID = UUID().uuidString
        // Setup simple ping & start
        pinger = SimplePing(hostName: hostname)
        // set self as delegate
        pinger?.delegate = self
        // notify delegate that service will begin
        pingerWillStart()
        // start
        pinger?.start()
    }
    /// Stops the ping service with tightly
    /// controlled service suspension, delegate
    /// notification, service deallocation and
    /// variable resets.
    internal func stop() {
        // stop the pinger
        pinger?.stop()
        // notify the delegate
        pingerDidStop()
        // deallocated services
        deallocateFrameworks()
        // reset the variables to
        // default values
        resetPingEventVars()
    }
    /// Stops the ping service with after
    /// a configured timer expired.
    @objc internal func timeExpired() {
        // notify the delegate
        delegate?.gblPingEvent(.pingTimeExpired)
        // stop the service
        stop()
    }
}
/// An inaccessible extension for critical state management functions.
fileprivate extension GBLPingService {
    /// Sets all services instances nil.
    func deallocateFrameworks() {
        pinger = nil
    }
    /// Resets all config & state variables related to a ping event.
    func resetPingEventVars() {
        maxPings = nil
        timeLimit = nil
        pingAttempts = nil
    }
}

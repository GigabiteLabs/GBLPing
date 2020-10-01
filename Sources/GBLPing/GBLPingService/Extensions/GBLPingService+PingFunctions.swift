// GBLPingService+PingFunctions.swift
//
// Created by GigabiteLabs on 9/29/20
// Swift Version: 5.0
// Copyright © 2020 GigabiteLabs. All rights reserved.
//

import Foundation
import GBLPingLib

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
    internal func startPinging(_ hostname: String) {
        #if DEBUG
        print("Internal: \(#function)")
        #endif

        resetPingEventVars()
        // setup / reset the result type for current service operation
        lastPingEventType = .pingReadyToStart
        // setup new squence ID
        self.cache.currentSequenceID = UUID().uuidString
        // Setup simple ping & start
        cache.pinger = SimplePing(hostName: hostname)
        // set self as delegate
        cache.pinger?.delegate = self
        // notify delegate that service will begin
        pingerWillStart()
        // start
        cache.pinger?.start()
        // setup repeat timer
        setupPingTimer()
    }

    /// Stops the ping service with tightly
    /// controlled service suspension, delegate
    /// notification, service deallocation and
    /// variable resets.
    public func stop() {
        #if DEBUG
        print("Internal: \(#function)")
        #endif

        // stop the timer
        stopTimer()
        // stop the pinger
        cache.pinger?.stop()
        // notify the delegate
        pingerDidStop()
        // deallocated services
        deallocateFrameworks()
        // reset the variables to
        // default values
        resetPingEventVars()
    }
    func setupPingTimer() {
        cache.sendTimer = Timer.scheduledTimer(timeInterval: 1.0,
                                         target: self,
                                         selector: #selector(sendPing),
                                         userInfo: nil,
                                         repeats: true)

    }
    func stopTimer() {
        cache.sendTimer?.invalidate()
        cache.sendTimer = nil
    }
    /// Sends a ping.
    ///
    /// Called to send a ping, both directly (as soon as the SimplePing object starts up) and
    /// via a timer (to continue sending pings periodically).

    @objc internal func sendPing() {
        self.cache.pinger?.send(with: nil)
    }
    /// Stops the ping service with after
    /// a configured timer expired.
    @objc internal func timeExpired() {
        #if DEBUG
        print("Internal: \(#function)")
        #endif

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
        #if DEBUG
        print("Internal: \(#function)")
        #endif

        cache.pinger = nil
    }
    /// Resets all config & state variables related to a ping event.
    func resetPingEventVars() {
        #if DEBUG
        print("Internal: \(#function)")
        #endif

        cache.stopScheduled = false
        cache.timeLimit = nil
        cache.pingAttempts = nil
    }
}

//
//  GBLPing.swift
//  
//
//  Created by GigabiteLabs 
//  Copyright © 2019 GigabiteLabs. All rights reserved.
//
import Foundation
import SimplePing

/// A class representation of GBLPing as an instantiatable service.
public final class GBLPingService: NSObject, SimplePingDelegate  {
    /// Assignable to an object conforming to `GBLPingDelegate` protocal
    /// delegated responsibility for recieving notifications for
    /// ping service lifecycle events and errors.
    public var delegate: GBLPingDelegate?
    /// Assignable to an object conforming to `GBLPingDataDelegate` protocal
    /// delegated responsibility for recieving `GBLPingResult` objects captured from
    /// a running ping event.
    ///
    /// - Note: Inherits from `GBLPingDelegate`, requires
    /// all functions for both protocols to be adopted.
    ///
    public var dataDelegate: GBLPingDataDelegate?
    // Class Variables & Types
    /// The SimplePing client
    internal var pinger: SimplePing?
    /// An ID representing a unique sequence of ping attempts to which `GBLPingResults` belong.
    internal var currentSequenceID: String?
    private var lastEventType: GBLPingEvent = .pingReadyToStart
    /// A variable of type `GBLPingEvent` describing the very last type of event that occured.
    /// The default value is `.pingReadyToStart`.
    ///
    /// - Note: This variable is updated internally with every event that occurs.
    internal(set) public var lastPingEventType: GBLPingEvent {
        get {
            return lastEventType
        }
        set {
            lastEventType = newValue
            // notify delegate of event
            delegate?.gblPingEvent(newValue)
        }
    }
    /// A private var to reference a configured number for the max number of pings to send
    internal var maxPings: Int?
    /// A configuration setting describing the number of seconds
    /// that a ping sessing should automatically stop after.
    internal var timeLimit: Int?
    /// A holder var for a timer, instantiated when a ping event
    /// is started that limited to a number of seconds.
    internal var timer: Timer?
    /// A private var to track the number of pings sent during an operation with limitations applied
    /// on the maximum number of pings to send
    internal var pingAttempts: Int?
    /// An optional array of `[GBLPingResult]` that has been cached locally, or nil if none has ever been saved.
    public var pingResults: [GBLPingResult]?
    /// the currently in-process ping event result.
    public var currentPingResult: GBLPingResult?
    /// Initializes the service instance and retrieves cached results
    /// if caching is enabled.
    public override init() {
        super.init()
        // recall cached results and store
        // in memory on shared instance as
        // soon as init runs
//        pingResults = cachedResults
    }
    
    deinit {
        // save in-memory results to cache
        // before garbage collection or deinit
//        cachedResults = pingResults
    }
    /// Pings a hostname continuously until either stopped or
    /// deallocated by the operating system.
    ///
    /// - Parameters:
    ///     - hostname: the hostname to ping, e.g.: gigabitelabs.com
    ///
    /// - Warning: If you use this function, make sure you
    /// also manually configure your application to stop, or it will
    /// continue indefinitely. In some cases, this could cause issues
    /// if not handled properly.
    ///
    public func pingHostname(hostname: String) {
        // reset for new operation
        startPinging(hostname)
    }
    /// Pings a hostname stopping after a designated number
    /// of pings.
    ///
    /// - Parameters:
    ///     - hostname: the hostname to ping, e.g.: gigabitelabs.com
    ///     - maxPings: the number of ping events the  service should
    ///     be limited to. The ping service stops automatically
    ///     when the number of ping events is reached.
    ///
    public func pingHostname(hostname: String, maxPings: Int) {
        // set max configuration on instance
        self.maxPings = maxPings
        // pass-through to hostname ping
        pingHostname(hostname: hostname)
    }
    /// Pings a hostname and stops after the configured
    /// amount of time.
    ///
    /// - Parameters:
    ///     - hostname: the hostname to ping, e.g.: gigabitelabs.com
    ///     - stopAfter: the amount of time in seconds the ping
    ///     event should be limited to. The ping service stops automatically
    ///     when the number of seconds elapses.
    ///
    public func pingHostname(hostname: String, stopAfter seconds: Int) {
        // set max configuration on instance
        self.timeLimit = seconds
        // pass-through to hostname ping
        pingHostname(hostname: hostname)
    }
}

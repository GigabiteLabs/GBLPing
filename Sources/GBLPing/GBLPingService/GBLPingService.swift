//
//  GBLPing.swift
//  
//
//  Created by GigabiteLabs 
//  Copyright © 2019 GigabiteLabs. All rights reserved.
//
import Foundation
import GBLPingLib

/// A class representation of GBLPing as an instantiatable service.
public final class GBLPingService: NSObject, SimplePingDelegate  {
    /// Assignable to an object conforming to `GBLPingDelegate` protocal
    /// delegated responsibility for recieving notifications for
    /// ping service lifecycle events and errors.
    public weak var delegate: GBLPingDelegate?
    /// Assignable to an object conforming to `GBLPingDataDelegate` protocal
    /// delegated responsibility for recieving `GBLPingResult` objects captured from
    /// a running ping event.
    ///
    /// - Note: Inherits from `GBLPingDelegate`, requires
    /// all functions for both protocols to be adopted.
    ///
    public weak var dataDelegate: GBLPingDataDelegate?
    // Class Variables & Types
    /// The SimplePing client
    internal var pinger: SimplePing?
    /// A timer that sends a new ping on each fire
    internal var sendTimer: Timer?
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
    /// An internal bool that stops the service after the
    /// next response is recieved.
    internal var stopScheduled: Bool = false
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
}

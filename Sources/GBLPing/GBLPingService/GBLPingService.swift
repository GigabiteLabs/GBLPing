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
public final class GBLPingService: NSObject, SimplePingDelegate {
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
    internal var cache: GBLPingServiceCache = .init()
    // Class Variables & Types
    /// A variable of type `GBLPingEvent` describing the very last type of event that occured.
    /// The default value is `.pingReadyToStart`.
    ///
    /// - Note: This variable is updated internally with every event that occurs.
    internal(set) public var lastPingEventType: GBLPingEvent {
        get {
            return cache.lastEventType
        }
        set {
            cache.lastEventType = newValue
            // invoke completion handling
            handleCompletion(event: newValue, result: currentPingResult)
            // notify delegate of event
            delegate?.gblPingEvent(newValue)
        }
    }
    /// An optional array of `[GBLPingResult]` that has been cached locally, or nil if none has ever been saved.
    public var pingResults: [GBLPingResult]?
    /// the currently in-process ping event result.
    public var currentPingResult: GBLPingResult?
    /// Initializes the service instance and retrieves cached results
    /// if caching is enabled.
    public override init() {
        super.init()
    }

    deinit { }
}

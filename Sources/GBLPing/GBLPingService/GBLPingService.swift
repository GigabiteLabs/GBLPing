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
    /// An object conforming to `GBLPingDelegate` protocol
    /// delegated responsibility for recieving `GBLPingResult` objects captured from
    /// a running ping event, as well as error events.
    public weak var delegate: GBLPingDelegate?
    /// A reference to an object confirming to the `GBLPingEventDelegate` protocol
    /// to recieve event updates for all state changes.
    public weak var eventDelegate: GBLPingEventDelegate?
    /// An internally accessible struct containing values and variables
    /// related to configuration, state, and other contextual values.
    internal var cache: GBLPingServiceCache = .init()
    /// A variable of type `GBLPingEvent` describing the very last type of event that occured.
    /// The default value is `.pingReadyToStart`.
    ///
    /// - Note: This variable is updated internally with every event that occurs.
    internal(set) public var lastPingEventType: GBLPingEvent {
        get {
            return cache.lastEventType
        }
        set {
            // cache the value
            cache.lastEventType = newValue
            // notify the event delegate
            eventDelegate?.gblPingEvent(newValue)
            
            // check if completion shoud be called
            switch newValue {
            case .responsePacketRecieved:
                guard
                    let reachabilityCompletion = cache.reachabilityCompletion,
                    let maxPings = cache.maxPings
                else {
                    return
                }
                // true after anything less than 2
                if maxPings < 2 {
                    reachabilityCompletion(true)
                }
            case .pingMaximumReached:
                if let pingHostCompletion = cache.pingHostCompletion {
                    pingHostCompletion(true)
                }
            default:
                break
            }
        }
    }
    /// An optional array of `[GBLPingResult]` that has been cached locally, or nil if none has ever been saved.
    public var pingResults: [GBLPingResult]?
    /// the currently in-process ping event result.
    public var currentPingResult: GBLPingResult?
}

// File.swift
//
// Created by GigabiteLabs on 9/30/20
// Swift Version: 5.0
// Copyright © 2020 GigabiteLabs. All rights reserved.
//

import Foundation
import GBLPingLib

internal struct GBLPingServiceCache {
    /// The SimplePing client
    var pinger: SimplePing?
    /// A timer that sends a new ping on each fire
    var sendTimer: Timer?
    /// The default ping host
    ///
    /// - Note: The default valur Cloudflare's
    /// main name server, which is a reliable and fast
    /// host in the U.S.: [ns.cloudflare.com]()
    var defaultPingHost: String {
        return "ns.cloudflare.com"
    }
    /// A default number of max pings to use when required
    /// internally for things like reachability testing.
    var defaultMaxPings = 10
    /// An ID representing a unique sequence of ping attempts to which `GBLPingResults` belong.
    var currentSequenceID: String?
    /// The last `GBLPingEvent` that occured.
    var lastEventType: GBLPingEvent = .pingReadyToStart
    /// A private var to reference a configured number for the max number of pings to send
    var maxPings: Int?
    /// A configuration setting describing the number of seconds
    /// that a ping sessing should automatically stop after.
    var timeLimit: Int?
    /// A holder var for a timer, instantiated when a ping event
    /// is started that limited to a number of seconds.
    var timer: Timer?
    /// A private var to track the number of pings sent during an operation with limitations applied
    /// on the maximum number of pings to send
    var pingAttempts: Int?
    /// An internal bool that stops the service after the
    /// next response is recieved.
    var stopScheduled: Bool = false
    /// An optional holder var for storing a completion
    /// block when one is passed during a call to pingHostname().
    var pingHostCompletion: ((GBLPingEvent, GBLPingResult?) -> Void)?
}

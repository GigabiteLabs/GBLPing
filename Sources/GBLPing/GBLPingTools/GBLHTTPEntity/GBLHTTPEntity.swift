// File.swift
//
// Created by GigabiteLabs on 10/1/20
// Swift Version: 5.0
// Copyright © 2020 GigabiteLabs. All rights reserved.
//

import Foundation

public class GBLHTTPEntity {
    /// Checks if an internet connection is active in general
    /// or if a particualr host is reachable.
    ///
    /// - Returns:
    ///     - `(Bool) -> Void`, a closure with a boolean value indicating if the internet is reachable
    ///
    func reachable(hostName: String?, status: @escaping (Bool) -> Void) {
        // init a new ping service
        let pingSvc = GBLPing.serviceInstance
        // dermine which hostname to use
        var host = ""
        if let hostName = hostName {
            host = hostName
        } else {
            host = pingSvc.cache.defaultPingHost
        }
        // start pinging
        pingSvc.pingHostname(
            hostname: host,
            maxPings: pingSvc.cache.defaultMaxPings) { ( event, result) in
            // check if result is nil, if so
            // an error can be assumed and false
            // is passed back through the completion handler
            if result == nil {
                status(false)
                return
            }
            // If result was not nil
            // we handle completion by
            // what type of event happend
            switch event {
            case .responsePacketRecieved:
                status(true)
            case .unexpectedEvent,
                 .unexpectedPacketRecieved,
                 .pingFailure,
                 .maxPingsReached,
                 .pingMaximumReached:
                status(false)
            default:
                status(false)
            }
        }
    }
}

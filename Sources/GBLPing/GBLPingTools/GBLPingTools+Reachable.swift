// File.swift
//
// Created by GigabiteLabs on 9/30/20
// Swift Version: 5.0
// Copyright © 2020 GigabiteLabs. All rights reserved.
//

import Foundation

extension GBLPingTools {
    // TODO: add reachability tools
    public func internetReachable(reachable: @escaping (Bool) -> Void) {
        let pingSvc = GBLPing.serviceInstance
        pingSvc.pingHostname(
            hostname: pingSvc.cache.defaultPingHost,
            maxPings: pingSvc.cache.defaultMaxPings) { ( event, result) in

            // check if result is nil, if so
            // an error can be assumed and false
            // is passed back through the completion handler
            if result == nil {
                reachable(false)
                return
            }
            // If result was not nil
            // we handle completion by
            // what type of event happend
            switch event {
            case .responsePacketRecieved:
                reachable(true)
            case .unexpectedEvent,
                 .unexpectedPacketRecieved,
                 .pingFailure,
                 .maxPingsReached,
                 .pingMaximumReached:
                reachable(false)
            default:
                print("\n\nERROR: UNHANDLED case sent to completion\n\n")
                reachable(false)
            }
        }
    }
    public static func hostReachable(_ hostname: String) {

    }
}

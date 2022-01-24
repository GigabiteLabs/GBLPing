// File.swift
//
// Created by GigabiteLabs on 9/30/20
// Swift Version: 5.0
// Copyright © 2020 GigabiteLabs. All rights reserved.
//

import Foundation

extension GBLPingService {
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
    public func pingHostname(hostname: String, _ completion: ((Bool) -> Void)? = nil) {
        // reset for new operation
        cache.pingHostCompletion = completion
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
    public func pingHostname(hostname: String, maxPings: Int, _ completion: ((Bool) -> Void)? = nil) {
        // set max configuration on instance
        cache.maxPings = maxPings
        // pass-through to hostname ping
        pingHostname(hostname: hostname, completion)
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
    public func pingHostname(hostname: String, stopAfter seconds: Int, _ completion: ((Bool) -> Void)? = nil) {
        // set max configuration on instance
        cache.timeLimit = seconds
        // pass-through to hostname ping
        pingHostname(hostname: hostname, completion)
    }

}

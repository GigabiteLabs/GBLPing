// GBLPingService+ForcingIPVersion.swift
//
// Created by GigabiteLabs on 9/29/20
// Swift Version: 5.0
// Copyright © 2020 GigabiteLabs. All rights reserved.
//

import Foundation

extension GBLPingService {
    /// Pings a hostname continuously until either stopped or
    /// deallocated by the operating system. Ping events will be
    /// explicitly forced use either an ICMP version v4 or v6 IP addresss.
    ///
    /// - Parameters:
    ///     - ipVersion: a `GBLPingIPVersion` configuration that will restrict
    ///     the ping service to the configured icmp IP version.
    ///     - hostname: the hostname to ping, e.g.: gigabitelabs.com
    ///
    /// - Warning: If you use this function, make sure you
    /// also manually configure your application to stop, or it will
    /// continue indefinitely. In some cases, this could cause issues
    /// if not handled properly.
    ///
    public func pingHostnameForcing(ipVersion: GBLPingIPVersion, hostname: String) {
        // setup ip configuration
        switch ipVersion {
        case .ipv4:
            pinger?.addressStyle = .icmPv4
        case .ipv6:
            pinger?.addressStyle = .icmPv6
        }
        // start service
        startPinging(hostname)
    }
    /// Pings a hostname stopping after a designated number
    /// of pings, while explicitly forcing ping events to use
    /// either to use either an ICMP version v4 or v6 IP addresss.
    ///
    /// - Parameters:
    ///     - ipVersion: a `GBLPingIPVersion` configuration that will restrict
    ///     the ping service to the configured icmp IP version.
    ///     - hostname: the hostname to ping, e.g.: gigabitelabs.com
    ///     - maxPings: the number of ping events the  service should
    ///     be limited to. The ping service stops automatically
    ///     when the number of ping events is reached.
    ///
    public func pingHostnameForcing(ipVersion: GBLPingIPVersion, hostname: String, maxPings: Int) {
        // Ensure the setting for max pings is not zero.
        if !(maxPings > 0) {
            delegate?.pingError(error: .maxPingsInvalid)
        }
        // set max ping configuration on service
        self.maxPings = maxPings
        // pass-through to basic forcing func
        pingHostnameForcing(ipVersion: ipVersion, hostname: hostname)
    }
    /// Pings a hostname and stops after the configured
    /// amount of time.while explicitly forcing ping events to use
    /// either to use either an ICMP version v4 or v6 IP addresss.
    ///
    /// - Parameters:
    ///     - ipVersion: a `GBLPingIPVersion` configuration that will restrict
    ///     the ping service to the configured icmp IP version.
    ///     - hostname: the hostname to ping, e.g.: gigabitelabs.com
    ///     - stopAfter: the amount of time in seconds the ping
    ///     event should be limited to. The ping service stops automatically
    ///     when the number of seconds elapses.
    ///
    public func pingHostnameForcing(ipVersion: GBLPingIPVersion, hostname: String, stopAfter seconds: Int) {
        // Ensure the setting for max pings is not zero.
        if !(seconds > 1) {
            delegate?.pingError(error: .timeLimitInvalid)
        }
        // set max ping configuration on service
        self.timeLimit = seconds
        // pass-through to basic forcing func
        pingHostnameForcing(ipVersion: ipVersion, hostname: hostname)
    }
}

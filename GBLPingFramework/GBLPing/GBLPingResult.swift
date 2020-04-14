// GBLPingResult.swift
//
// Created by GigabiteLabs on 4/14/20
// Swift Version: 5.0
// Copyright © 2020 GigabiteLabs. All rights reserved.
//



import Foundation

public struct GBLPingResult {
    /// The number of bytes that represent the data size of the result
    var bytes: Int?
    /// The sequence number of the this result within the overall ping event type
    var pingSequenceNumber: UInt16?
    /// The type of event that produced the result
    var event: GBLPingEvent?
    /// Time ping event started in UTC epoch
    var startTime: Int?
    /// Time ping event ended in UTC epoch
    var endTime: Int?
    /// Total round trip time between request and response for this result in ms
    var roundTrip: Int {
        return (endTime ?? 0) - (startTime ?? 1)
    }
    /// Hostname targeted in this result
    var targetHost: String?
    /// Resolved IP address of the targeted host
    var targetHostIP: String?
    /// If IPv4 was forced
    var ipv4Forced: Bool?
    /// IPv4 address
    var ipv4Address: String?
    /// If IPv6 was forced
    var ipv6Forced: Bool?
    /// IPv4 address
    var ipv6Address: String?
    /// Flag for if an unexpected event occured
    var unexpectedEvent: GBLPingUnexpectedEvent?
    /// Time the unexpected event occured
    var unexpectedEventTime: Int?
    /// The raw response data
    var rawPacket: Data?
    /// Result message
    var resultMessage: String?
}

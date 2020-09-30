// GBLPingResult.swift
//
// Created by GigabiteLabs on 4/14/20
// Swift Version: 5.0
// Copyright © 2020 GigabiteLabs. All rights reserved.
//

import Foundation

/// An object representing the result of an individual ping event, including metrics.
@objc public class GBLPingResult: NSObject, Codable {
    /// A unique ID string for the sequence to which this result belongs.
    var sequenceID: String = ""
    /// The number of bytes that represent the data size of the result.
    var bytes: Int = 0
    /// The sequence number of the this result within the overall ping event type.
    var pingSequenceNumber: UInt16?
    /// The type of event that produced the result.
    var event: GBLPingEvent = .resultInitialized
    /// Time ping event started in UTC epoch.
    var startTime: Int = 0
    /// Time ping event ended in UTC epoch.
    var endTime: Int = 0
    /// Total round trip time between request and response for this result in ms.
    var roundTrip: Int {
        return endTime - startTime
    }
    /// Hostname targeted in this result.
    var targetHost: String = ""
    /// Resolved IP address of the targeted host.
    var targetHostIP: String = ""
    /// If IPv4 was forced.
    var ipv4Forced: Bool = false
    /// IPv4 address.
    var ipv4Address: String = ""
    /// If IPv6 was forced.
    var ipv6Forced: Bool = false
    /// IPv4 address.
    var ipv6Address: String = ""
    /// Flag for if an unexpected event occured.
    var unexpectedEvent: GBLPingUnexpectedEvent = .resultInitialized
    /// Time the unexpected event occured.
    var unexpectedEventTime: Int = 0
    /// The raw response data.
    var rawPacket: Data = Data()
    /// Result message.
    var resultMessage: String = ""
    /// A required initializer for `Codable` protocol.
    internal required override init() { }
    /// keys for encoding
    public enum CodingKeys: String, CodingKey {
        case sequenceID
        case bytes
        case pingSequenceNumber
        case event
        case startTime
        case endTime
        case targetHost
        case targetHostIP
        case ipv4Forced
        case ipv4Address
        case ipv6Forced
        case ipv6Address
        case unexpectedEvent
        case unexpectedEventTime
        case rawPacket
        case resultMessage
    }
    public func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encode(sequenceID, forKey: .sequenceID)
        try container.encode(bytes, forKey: .bytes)
        try container.encode(pingSequenceNumber, forKey: .pingSequenceNumber)
        try container.encode(event.rawValue , forKey: .event)
        try container.encode(startTime, forKey: .startTime)
        try container.encode(endTime, forKey: .endTime)
        try container.encode(targetHost, forKey: .targetHost)
        try container.encode(targetHostIP, forKey: .targetHostIP)
        try container.encode(ipv4Forced, forKey: .ipv4Forced)
        try container.encode(ipv4Address, forKey: .ipv4Address)
        try container.encode(ipv6Forced, forKey: .ipv6Forced)
        try container.encode(ipv6Address, forKey: .ipv6Address)
        try container.encode(unexpectedEvent.rawValue, forKey: .unexpectedEvent)
        try container.encode(unexpectedEventTime, forKey: .unexpectedEventTime)
        try container.encode(rawPacket, forKey: .rawPacket)
        try container.encode(resultMessage, forKey: .resultMessage)
        
    }
    /// Codable decode function
    public required init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        sequenceID = try container.decode(String.self, forKey: .sequenceID)
        bytes = try container.decode(Int.self, forKey: .bytes)
        pingSequenceNumber = try container.decode(UInt16.self, forKey: .pingSequenceNumber)
        event = try container.decode(GBLPingEvent.self, forKey: .event)
        startTime = try container.decode(Int.self, forKey: .startTime)
        endTime = try container.decode(Int.self, forKey: .endTime)
        targetHost = try container.decode(String.self, forKey: .targetHost)
        targetHostIP = try container.decode(String.self, forKey: .targetHostIP)
        ipv4Forced = try container.decode(Bool.self, forKey: .ipv4Forced)
        ipv4Address = try container.decode(String.self, forKey: .ipv4Address)
        ipv6Forced = try container.decode(Bool.self, forKey: .ipv6Forced)
        ipv6Address = try container.decode(String.self, forKey: .ipv6Address)
        unexpectedEvent = try container.decode(GBLPingUnexpectedEvent.self, forKey: .unexpectedEvent)
        unexpectedEventTime = try container.decode(Int.self, forKey: .unexpectedEventTime )
        rawPacket = try container.decode(Data.self, forKey: .rawPacket)
        resultMessage = try container.decode(String.self, forKey: .resultMessage)
        super.init()
    }
}

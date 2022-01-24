// GBLPing+DelegateFunctions.swift
//
// Created by GigabiteLabs on 4/14/20
// Swift Version: 5.0
// Copyright © 2020 GigabiteLabs. All rights reserved.
//

import Foundation
import GBLPingLib

/// An extension of `GBLPingService`for ping operation lifecycle events w/ helper functions
public extension GBLPingService {
    /// Handles ping service start event configuration
    func pingerWillStart() {
        // update event type
        lastPingEventType = .pingWillStart
        // add new result
        let newResult = GBLPingResult()
        if let currentSequenceID = cache.currentSequenceID {
            newResult.sequenceID = currentSequenceID
        }
        addNewResult(result: newResult)
    }
    /// Handles ping service stoppage configuration.
    func pingerDidStop() {
        lastPingEventType = .pingDidStop
    }
    /// Recieves event updates from `SimplePing` for service start.
    func simplePing(_ pinger: SimplePing, didStartWithAddress address: Data) {
        // start the timer if exits
        if let timeLimit = cache.timeLimit {
            perform(#selector(timeExpired), with: nil, afterDelay: TimeInterval(timeLimit))
        }
        // update event
        lastPingEventType = .pingDidStart

        // send the ping!
        pinger.send(with: nil)

        // translate the address from Data to String
        let translatedAddress = "\(displayAddressForAddress(address: address as NSData))"
            
        // capture start time & packet sent
        guard
            let pingResult = latestResult()
        else {
            return
        }
        // capture IP address for ipv forcing
        if pingResult.ipv4Forced == true {
            pingResult.ipv4Address = translatedAddress
        } else if pingResult.ipv6Forced == true {
            pingResult.ipv6Address = translatedAddress
        }
        // capture ipv4 as target host in any case
        pingResult.targetHostIP = translatedAddress
        pingResult.targetHost = pinger.hostName
        pingResult.resultMessage = "ping service started pinging recipient at IP address \(pingResult.targetHostIP)"
        updatePingResults(result: pingResult)
    }
    /// Recieves event updates from `SimplePing` for packet send events.
    func simplePing(_ pinger: SimplePing, didSendPacket packet: Data, sequenceNumber: UInt16) {
        // update event
        lastPingEventType = .packetSent
        // check if we've reached max
        checkIfMaxPingsReached()
        // capture start time & packet sent
        guard
            let pingResult = latestResult()
        else {
            return
        }
        pingResult.startTime = Int(NSDate().timeIntervalSince1970)
        pingResult.rawPacket = packet
        pingResult.pingSequenceNumber = Int(sequenceNumber)
        pingResult.bytes = packet.count

        // gather data and log for debugging
        let msg = "ping sequence#\(sequenceNumber) was successfully sent"
        pingResult.resultMessage = msg
        
        updatePingResults(result: pingResult)
    }
    /// Recieves event updates from `SimplePing` related to packet sending failures.
    func simplePing(_ pinger: SimplePing, didFailToSendPacket packet: Data, sequenceNumber: UInt16, error: Error, completion: @escaping (Bool) -> Void) {
        // update event
        lastPingEventType = .pingFailure
        // Check if it should stop
        checkIfStopScheduled()
        // capture start time & packet sent
        guard
            let pingResult = latestResult()
        else {
            return
        }
        // gather data and log for debugging
        let shortError = self.shortErrorFromError(error: error as NSError)
        let msg = "ping sequence #\(sequenceNumber) failed to send with error: \(shortError)"
        pingResult.resultMessage = msg
        pingResult.failureEventTime = Int(NSDate().timeIntervalSince1970)
        updatePingResults(result: pingResult)
    }
}

/// An extension for `GBLPingService` with functions corresponding to ping operation outcomes.
public extension GBLPingService {
    /// A delegate function that handles the failure of a ping attempt or operation.
    func simplePing(_ pinger: SimplePing, didFailWithError error: Error) {
        // update event
        lastPingEventType = .pingFailure
        // gather data and log for debugging
        let msg = "failed: \(self.shortErrorFromError(error: error as NSError))"; print(msg); NSLog(msg)
        print("GBLPing ::: ERROR ::: \(msg)")
        // Check if it should stop
        checkIfStopScheduled()
    }
    /// A delegate function that handles reception of a response to a ping.
    func simplePing(_ pinger: SimplePing, didReceivePingResponsePacket packet: Data, sequenceNumber: UInt16) {
        // update event
        lastPingEventType = .responsePacketRecieved
        // Check if it should stop
        checkIfStopScheduled()
        // get latest result
        guard
            let pingResult = latestResult()
        else {
            return
        }
        // capture start time & data
        pingResult.endTime = Int(NSDate().timeIntervalSince1970)
        pingResult.rawPacket = packet
        pingResult.pingSequenceNumber = Int(sequenceNumber)
        pingResult.bytes = packet.count

        // setup message string
        pingResult.resultMessage = "ping sequence #\(sequenceNumber) received, size: \(packet.count)"

        // notify delegate
        delegate?.gblPingResult(result: pingResult)
        // reset for next ping
        resetPingResult()
    }
    /// A delegate function that handles reception of an unexpected packet as a response to a ping.
    func simplePing(_ pinger: SimplePing, didReceiveUnexpectedPacket packet: Data) {
        // update event
        lastPingEventType = .unexpectedPacketRecieved
        // Check if it should stop
        checkIfStopScheduled()
        
        // get latest result
        guard
            let pingResult = latestResult()
        else {
            return
        }
        // set start time, event, raw data, and message
        pingResult.unexpectedEventTime = Int(NSDate().timeIntervalSince1970)
        pingResult.unexpectedEvent = .packetDiscrepancy
        pingResult.rawPacket = packet
        pingResult.bytes = packet.count
        pingResult.resultMessage = "unexpected response recieved. packet count: \(packet.count)"
        // notify delegate
        delegate?.gblPingResult(result: pingResult)

    }
}

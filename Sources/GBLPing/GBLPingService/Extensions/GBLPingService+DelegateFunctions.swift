// GBLPing+DelegateFunctions.swift
//
// Created by GigabiteLabs on 4/14/20
// Swift Version: 5.0
// Copyright © 2020 GigabiteLabs. All rights reserved.
//

import Foundation

/// An extension of `GBLPingService`for ping operation lifecycle events w/ helper functions
public extension GBLPingService {
    
    func pingerWillStart() {
        // update event type
        lastPingEventType = .pingWillStart
        // add new result
        let newResult = GBLPingResult()
        
        if let currentSequenceID = currentSequenceID {
            newResult.sequenceID = currentSequenceID
        }
        addNewResult(result: newResult)
    }
    
    func pingerDidStop() {
        lastPingEventType = .pingDidStop
    }
    
    func simplePing(_ pinger: SimplePing, didStartWithAddress address: Data) {
        // start the timer if exits
        if let timeLimit = timeLimit {
            perform(#selector(timeExpired), with: nil, afterDelay: TimeInterval(timeLimit))
        }
        // update event
        lastPingEventType = .pingDidStart
        
        // send the ping!
        pinger.send(with: nil)
        
        // translate the address from Data to String
        let translatedAddress = "\(displayAddressForAddress(address: address as NSData))"
        
        // capture IP address for ipv forcing
        let pingResult = latestResult()
        if pingResult.ipv4Forced == true {
            pingResult.ipv4Address = translatedAddress
        } else if pingResult.ipv6Forced == true {
            pingResult.ipv6Address = translatedAddress
        }
        // capture ipv4 as target host in any case
        pingResult.targetHostIP = translatedAddress
        
        // gather data and log for debugging
        let stringRep = displayAddressForAddress(address: address as NSData)
        let msg = "ping service started pinging recipient at IP address \(stringRep)"
        pingResult.resultMessage = msg
        
        updatePingResults(result: pingResult)
    }
    
    func simplePing(_ pinger: SimplePing, didSendPacket packet: Data, sequenceNumber: UInt16) {
        // capture start time & packet sent
        let pingResult = latestResult()
        pingResult.startTime = Int(NSDate().timeIntervalSince1970)
        pingResult.rawPacket = packet
        pingResult.pingSequenceNumber = sequenceNumber
        pingResult.bytes = packet.count
        
        // gather data and log for debugging
        let msg = "ping sequence#\(sequenceNumber) was successfully sent"
        pingResult.resultMessage = msg
        
        // update event
        lastPingEventType = .packetSent
        
        updatePingResults(result: pingResult)
    }
    
    func simplePing(_ pinger: SimplePing, didFailToSendPacket packet: Data, sequenceNumber: UInt16, error: Error, completion: @escaping (Bool)-> Void) {
        // gather data and log for debugging
        let shortError = self.shortErrorFromError(error: error as NSError)
        let msg = "ping sequence #\(sequenceNumber) failed to send with error: \(shortError)"; print(msg)
        // update event
        lastPingEventType = .pingFailure
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
    }
    /// A delegate function that handles reception of a response to a ping.
    func simplePing(_ pinger: SimplePing, didReceivePingResponsePacket packet: Data, sequenceNumber: UInt16) {
        let pingResult = latestResult()
        // capture start time & data
        pingResult.endTime = Int(NSDate().timeIntervalSince1970)
        pingResult.rawPacket = packet
        pingResult.pingSequenceNumber = sequenceNumber
        pingResult.bytes = packet.count
        
        // setup message string
        pingResult.resultMessage = "ping sequence #\(sequenceNumber) received, size: \(packet.count)"
        
        // update event
        lastPingEventType = .responsePacketRecieved
        // notify delegate
        dataDelegate?.gblPingResult(result: pingResult)
        
        // reset for next ping
        resetPingResult()
    }
    /// A delegate function that handles reception of an unexpected packet as a response to a ping.
    func simplePing(_ pinger: SimplePing, didReceiveUnexpectedPacket packet: Data) {
        let pingResult = latestResult()
        // capture start time, event, raw data
        pingResult.unexpectedEventTime = Int(NSDate().timeIntervalSince1970)
        pingResult.unexpectedEvent = .packetDiscrepancy
        pingResult.rawPacket = packet
        pingResult.bytes = packet.count
        
        // setup msg
        let msg = "unexpected response recieved. packet count: \(packet.count)"
        pingResult.resultMessage = msg
        
        // update event
        lastPingEventType = .unexpectedPacketRecieved
        // notify delegate
        dataDelegate?.gblPingResult(result: pingResult)
    }
}

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
        var newResult = GBLPingResult()
        newResult.sequenceID = self.currentSequenceID
        addNewResult(result: newResult)
        
        let msg = "starting ping service"
        delegate?.pingEventOccured(event: .pingWillStart, description: msg, unexpectedEventType: nil)
        dataDelegate?.pingEventOccured(event: .pingDidStop, description: msg, unexpectedEventType: nil)
    }
    
    func pingerDidStop() {
        let msg = "the ping service has been stopped"
        lastPingEventType = .pingDidStop
        delegate?.pingEventOccured(event: .pingDidStop, description: msg, unexpectedEventType: nil)
        dataDelegate?.pingEventOccured(event: .pingDidStop, description: msg, unexpectedEventType: nil)
    }
    
    func simplePing(_ pinger: SimplePing, didStartWithAddress address: Data) {
        // start the timer if exits
        if let timeLimit = timeLimit {
            perform(#selector(timeExpired), with: nil, afterDelay: TimeInterval(timeLimit))
        }
        
        // send the ping!
        pinger.send(with: nil)
        
        // update event
        lastPingEventType = .pingDidStart
        
        // translate the address from Data to String
        let translatedAddress = "\(displayAddressForAddress(address: address as NSData))"
        
        // capture IP address for ipv forcing
        var pingResult = latestResult(for: currentSequenceID!)
        if let ipv4 = pingResult.ipv4Forced, ipv4 == true {
            pingResult.ipv4Address = translatedAddress
        } else if let ipv6 = pingResult.ipv6Forced, ipv6 == true {
            pingResult.ipv6Address = translatedAddress
        }
        // capture ipv4 as target host in any case
        pingResult.targetHostIP = translatedAddress
        
        // gather data and log for debugging
        let stringRep = displayAddressForAddress(address: address as NSData)
        let msg = "ping service started pinging recipient at IP address \(stringRep)"
        pingResult.resultMessage = msg
        
        // replace the old result version with new
        updateCurrentresult(result: pingResult)
        
        // Notify delegate
        delegate?.pingEventOccured(event: .pingDidStart, description: msg, unexpectedEventType: nil)
        dataDelegate?.pingEventOccured(event: .pingDidStart, description: msg, unexpectedEventType: nil)
    }
    
    func simplePing(_ pinger: SimplePing, didSendPacket packet: Data, sequenceNumber: UInt16) {
        // capture start time & packet sent
        var pingResult = latestResult(for: currentSequenceID!)
        pingResult.startTime = Int(NSDate().timeIntervalSince1970)
        pingResult.rawPacket = packet
        pingResult.pingSequenceNumber = sequenceNumber
        pingResult.bytes = packet.count
        
        // gather data and log for debugging
        let msg = "ping sequence#\(sequenceNumber) was successfully sent"
        pingResult.resultMessage = msg
        
        // replace the old result version with new
        updateCurrentresult(result: pingResult)
        
        // nofity delegates
        delegate?.pingEventOccured(event: .packetSent, description: msg, unexpectedEventType: nil)
        dataDelegate?.pingEventOccured(event: .packetSent, description: msg, unexpectedEventType: nil)
        // update event
        lastPingEventType = .packetSent
        
        // evalute if ping attempts were maxed out
        checkIfMaxPingsReached()
    }
    
    func simplePing(_ pinger: SimplePing, didFailToSendPacket packet: Data, sequenceNumber: UInt16, error: Error, completion: @escaping (Bool)-> Void) {
        // stop pinging
        stop()
        // gather data and log for debugging
        NSLog("#%u send failed: %@", sequenceNumber, self.shortErrorFromError(error: error as NSError))
        let shortError = self.shortErrorFromError(error: error as NSError)
        let msg = "ping sequence #\(sequenceNumber) failed to send with error: \(shortError)"; print(msg)
        // Notify delegate
        delegate?.pingEventOccured(
            event: .pingFailure,
            description: msg,
            unexpectedEventType: .internalError
        )
        dataDelegate?.pingEventOccured(event: .pingFailure, description: msg, unexpectedEventType: .internalError)
        // evalute if ping attempts were maxed out
        checkIfMaxPingsReached()
    }
    /// Handles internal checking if a maximum
    /// configured attempts has been reached
    private func checkIfMaxPingsReached(){
        // ensure a max was set, or just return
        guard let max = maxPings else {
            return
        }
        print("max ping config: \(max)")
        // get the current number of attempts
        let attempts = incrementAttempts()
        print("number of attempts: \(attempts)")
        // compare and stop if we've reached the max
        if attempts == max {
            stop()
        } else {
//            let pingResult = latestResult(for: currentSequenceID ?? "")
//            let latest = latestResult(for: currentSequenceID ?? "")
//            start(forceIPv4: pingResult.ipv4Forced ?? false, forceIPv6: pingResult.ipv6Forced ?? false, hostname: pingResult.targetHost ?? "gigabitelabs.com")
        }
    }
    /// Handles safe incrementation and retrieval of the number
    /// of attempts for the current ping operation.
    ///
    /// - Returns: `Int`, representing the number of attempted pings
    /// for the current operation after incrementation.
    ///
    /// - Note: The function handles the case a ping operation has never been
    /// attempted and will always return a number greater than or equal to 1.
    private func incrementAttempts() -> Int {
        if var attempts: Int = pingAttempts, attempts > 0 {
            attempts += 1
            pingAttempts = attempts
            return attempts
        } else {
            pingAttempts = 1
            return 1
        }
    }
}

/// An extension for `GBLPingService` with functions corresponding to ping operation outcomes.
public extension GBLPingService {
    /// A delegate function that handles the failure of a ping attempt or operation.
    func simplePing(_ pinger: SimplePing, didFailWithError error: Error) {
        // stop service
        stop()
        // gather data and log for debugging
        let msg = "failed: \(self.shortErrorFromError(error: error as NSError))"; print(msg); NSLog(msg)
        // Notify delegate
        delegate?.pingEventOccured(
            event: .pingFailure,
            description: msg,
            unexpectedEventType: .unkownError
        )
        dataDelegate?.pingEventOccured(event: .pingFailure, description: msg, unexpectedEventType: .unkownError)
        // update event
        lastPingEventType = .pingFailure
    }
    /// A delegate function that handles reception of a response to a ping.
    func simplePing(_ pinger: SimplePing, didReceivePingResponsePacket packet: Data, sequenceNumber: UInt16) {
        var pingResult = latestResult(for: currentSequenceID ?? "")
        // capture start time & data
        pingResult.endTime = Int(NSDate().timeIntervalSince1970)
        pingResult.rawPacket = packet
        pingResult.pingSequenceNumber = sequenceNumber
        pingResult.bytes = packet.count
        
        // setup message string
        pingResult.resultMessage = "ping sequence #\(sequenceNumber) received, size: \(packet.count)"
        
        // replace the old result version with new
        updateCurrentresult(result: pingResult)
        print("\n\nresult: \(pingResult)")
        
        // update event
        lastPingEventType = .responsePacketRecieved
        
        // notify delegates
        dataDelegate?.pingResult(result: pingResult)
        delegate?.pingEventOccured(event: .responsePacketRecieved, description: pingResult.resultMessage ?? "", unexpectedEventType: nil)
    }
    /// A delegate function that handles reception of an unexpected packet as a response to a ping.
    func simplePing(_ pinger: SimplePing, didReceiveUnexpectedPacket packet: Data) {
        var pingResult = latestResult(for: currentSequenceID!)
        // capture start time, event, raw data
        pingResult.unexpectedEventTime = Int(NSDate().timeIntervalSince1970)
        pingResult.unexpectedEvent = .packetDiscrepancy
        pingResult.rawPacket = packet
        pingResult.bytes = packet.count
        
        // setup msg
        let msg = "unexpected response recieved. packet count: \(packet.count)"
        pingResult.resultMessage = msg
        
        // replace the old result version with new
        updateCurrentresult(result: pingResult)
        
        // update event
        lastPingEventType = .unexpectedPacketRecieved
        
        // notify delegates
        dataDelegate?.pingResult(result: pingResult)
        delegate?.pingEventOccured(event: .unexpectedPacketRecieved, description: msg, unexpectedEventType: .packetDiscrepancy)
    }
}

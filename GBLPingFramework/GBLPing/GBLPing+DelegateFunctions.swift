// GBLPing+DelegateFunctions.swift
//
// Created by GigabiteLabs on 4/14/20
// Swift Version: 5.0
// Copyright © 2020 GigabiteLabs. All rights reserved.
//

import Foundation

// TODO: Documentation, refactoring
public extension GBLPingService {
    
    func simplePing(_ pinger: SimplePing, didStartWithAddress address: Data) {
        // send the ping!
        pinger.send(with: nil)
        
        // translate the address from Data to String
        let translatedAddress = "\(displayAddressForAddress(address: address as NSData))"
        
        // capture IP address for ipv forcing
        if let ipv4 = pingResult.ipv4Forced, ipv4 == true {
            pingResult.ipv4Address = translatedAddress
        } else if let ipv6 = pingResult.ipv6Forced, ipv6 == true {
            pingResult.ipv6Address = translatedAddress
        }
        
        // capture ipv4 as target host in any case
        pingResult.targetHostIP = translatedAddress
        
        // gather data and log for debugging
        let stringRep = displayAddressForAddress(address: address as NSData)
        let msg = "ping service started pinging recipient at IP address \(stringRep)"; print(msg); NSLog(msg)
        
        // Notify delegate
        delegate?.gblPingEventDidOccur(event: .pingDidStart, description: msg, unexpectedEventType: nil)
    }
    
    func simplePing(_ pinger: SimplePing, didFailWithError error: Error) {
        // stop service
        stop()
        // gather data and log for debugging
        let msg = "failed: \(self.shortErrorFromError(error: error as NSError))"; print(msg); NSLog(msg)
        // Notify delegate
        delegate?.gblPingEventDidOccur(
            event: .pingFailure,
            description: msg,
            unexpectedEventType: .unkownError
        )
    }
    
    func simplePing(_ pinger: SimplePing, didSendPacket packet: Data, sequenceNumber: UInt16) {
        // capture start time & packet sent
        pingResult.startTime = Int(NSDate().timeIntervalSince1970)
        pingResult.rawPacket = packet
        pingResult.pingSequenceNumber = sequenceNumber
        pingResult.bytes = packet.count
        
        // gather data and log for debugging
        let msg = "ping sequence#\(sequenceNumber) was successfully sent"; print(msg); NSLog(msg)
        // Nofity delegate
        delegate?.gblPingEventDidOccur(
            event: .packetSent,
            description: msg,
            unexpectedEventType: nil
        )
        dataDelegate?.pingResult(result: pingResult)
        print(pingResult)
    }
    
    func simplePing(_ pinger: SimplePing, didFailToSendPacket packet: Data, sequenceNumber: UInt16, error: Error, completion: @escaping (Bool)-> Void) {
        // stop pinging
        stop()
        // gather data and log for debugging
        NSLog("#%u send failed: %@", sequenceNumber, self.shortErrorFromError(error: error as NSError))
        let shortError = self.shortErrorFromError(error: error as NSError)
        let msg = "ping sequence #\(sequenceNumber) failed to send with error: \(shortError)"; print(msg)
        // Notify delegate
        delegate?.gblPingEventDidOccur(
            event: .pingFailure,
            description: msg,
            unexpectedEventType: .internalError
        )
    }
    
    func simplePing(_ pinger: SimplePing, didReceivePingResponsePacket packet: Data, sequenceNumber: UInt16) {
        // capture start time & data
        pingResult.endTime = Int(NSDate().timeIntervalSince1970)
        pingResult.rawPacket = packet
        pingResult.pingSequenceNumber = sequenceNumber
        pingResult.bytes = packet.count
        
        print("GBLPing: #%u received, size=%zu", sequenceNumber, packet.count)
        let resultMessage = "ping sequence #\(sequenceNumber) received, size: \(packet.count)"
        pingResult.resultMessage = resultMessage
        
        // notify delegates
        delegate?.gblPingEventDidOccur(event: .packetRecieved, description: resultMessage, unexpectedEventType: nil)
        print(pingResult)
        dataDelegate?.pingResult(result: pingResult)
    }
    
    func simplePing(_ pinger: SimplePing, didReceiveUnexpectedPacket packet: Data) {
        // capture start time, event, raw data
        pingResult.unexpectedEventTime = Int(NSDate().timeIntervalSince1970)
        pingResult.unexpectedEvent = .packetDiscrepancy
        pingResult.rawPacket = packet
        pingResult.bytes = packet.count
        
        print("GBLPing: unexpected packet, size=%zu", packet.count)
        let msg = "unexpected response recieved. packet count: \(packet.count)"

        delegate?.gblPingEventDidOccur(event: .unexpectedEvent, description: "unexpected number of packets recieved. packet count: \(packet.count)", unexpectedEventType: .packetDiscrepancy)
        dataDelegate?.pingResult(result: pingResult)
        print(pingResult)
    }
    
    func pingerWillStart() {
        print("starting GBLPing")
        delegate?.gblPingEventDidOccur(event: .pingWillStart, description: "starting ping service", unexpectedEventType: nil)
    }
    
    func pingerDidStop() {
        print("stopped GBLPing")
        delegate?.gblPingEventDidOccur(event: .pingDidStop, description: "the ping service has been stopped", unexpectedEventType: nil)
    }
}

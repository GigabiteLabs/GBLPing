//
//  GBLPing.swift
//  
//
//  Created by GigabiteLabs 
//  Copyright © 2019 GigabiteLabs. All rights reserved.
//
import Foundation

/// A class representation of GBLPing
public class GBLPingService: NSObject, SimplePingDelegate  {
    
    // Delegates
    public var delegate: GBLPingDelegate?
    public var dataDelegate: GBLPingDataDelegate?
    
    // Class Variables & Types
    /// The SimplePing client
    var pinger: SimplePing?
    /// Current ping event result
    var pingResult: GBLPingResult = GBLPingResult()
    
    /// Eumerated error messages  for known states / issues
    private enum ErrorMsg: String {
        case bothIPVersionsSpecified = "both ipv4 and ipv6 was specified, only one or the other is supported."
        case noIPVersionsSpecified = "usage of this function requires an argument for either ipv4 or ipv6. both cannot be nil."
        case noHostName = "no hostname was provided."
        case invalidHostname = "an invalid hostname was provided."
    }
    
    // Public & Static functions
    /// Pings a provided hostname
    public func pingHostname(hostname: String) {
        // reset for new operation
        resetPingResult(host: hostname)
        
        // Setup simple ping & start
        pinger = SimplePing(hostName: hostname)
        pinger?.delegate = self
        pinger?.start()
    }
    /// Pings a provided hostname, but allows the option to force either ipv4 or ipv6.
    public func pingHostnameForcing(ipv4: Bool?, ipv6: Bool?, hostname: String) {
        // reset for new operation
        resetPingResult(host: hostname)
        
        let bothVersionsNil = (ipv4 == nil && ipv6 == nil)
        let bothVersionsSpecified = !(ipv4 == nil || ipv6 == nil)
        //
        if bothVersionsNil {
            delegate?.gblPingEventDidOccur (
                event: .unexpectedEvent,
                description: ErrorMsg.noIPVersionsSpecified.rawValue,
                unexpectedEventType: .invalidUsage
            )
        }
        if bothVersionsSpecified {
            delegate?.gblPingEventDidOccur (
                event: .unexpectedEvent,
                description: ErrorMsg.bothIPVersionsSpecified.rawValue,
                unexpectedEventType: .invalidUsage
            )
        }
        
        // capture ipv settings
        pingResult.ipv4Forced = ipv4 ?? false
        pingResult.ipv6Forced = ipv6 ?? false
        
        // setup simple ping & start
        pinger = SimplePing(hostName: hostname)
        pinger?.delegate = self
        pinger?.start()
    }
    /// Resets the result object for a new operation
    func resetPingResult(host: String){
        // setup / reset the result type for current service operation
        pingResult = GBLPingResult()
        pingResult.targetHost = host
    }
    /// Starts the pinging process by either IP or Hostname
    func start(forceIPv4: Bool, forceIPv6: Bool, hostname: String) {
        print("starting for hostname: \(hostname)")
        pingerWillStart()
        let pinger = SimplePing(hostName: hostname)
        self.pinger = pinger
        
        if (forceIPv4 && !forceIPv6) {
            pinger.addressStyle = .icmPv4
        } else if (forceIPv6 && !forceIPv4) {
            pinger.addressStyle = .icmPv6
        }
        pinger.delegate = self
        pinger.start()
        print("\(pinger)")
    }
    /// Stops the ping service
    func stop() {
        NSLog("stop")
        self.pinger?.stop()
        self.pinger = nil
        self.pingerDidStop()
    }

}

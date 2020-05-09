//
//  GBLPing.swift
//  
//
//  Created by GigabiteLabs 
//  Copyright © 2019 GigabiteLabs. All rights reserved.
//
import Foundation

/// A class representation of GBLPing
public final class GBLPingService: NSObject, SimplePingDelegate  {
    
    // Delegates
    public var delegate: GBLPingDelegate?
    public var dataDelegate: GBLPingDataDelegate?
    
    // Class Variables & Types
    /// The SimplePing client
    var pinger: SimplePing?
    /// An ID representing a unique sequence of ping attempts to which `GBLPingResults` belong.
    internal var currentSequenceID: String?
    /// A variable of type `GBLPingEvent` describing the very last type of event that occured.
    /// The default value is `.pingReadyToStart`.
    ///
    /// - Note: This variable is updated internally with every event that occurs.
    internal(set) public var lastPingEventType: GBLPingEvent = .pingReadyToStart
    /// A private var to reference a configured number for the max number of pings to send
    internal var maxPings: Int?
    /// A private var to track the number of pings sent during an operation with limitations applied
    /// on the maximum number of pings to send
    internal var pingAttempts: Int?
    /// Eumerated error messages  for known states / issues
    private enum ErrorMsg: String {
        case bothIPVersionsSpecified = "both ipv4 and ipv6 was specified, only one or the other is supported."
        case noIPVersionsSpecified = "usage of this function requires an argument for either ipv4 or ipv6. both cannot be nil."
        case noHostName = "no hostname was provided."
        case invalidHostname = "an invalid hostname was provided."
    }
    
    /// An optional array of `[GBLPingResult]` that has been cached locally, or nil if none has ever been saved.
    public var pingResults: [GBLPingResult]?
    /// An optional array of `[GBLPingResult]` that has been cached locally, or nil if none has ever been saved.
    internal var cachedResults: [GBLPingResult]? {
        get {
            guard let resultData = UserDefaults.standard.data(forKey: "GBLPing.ResultArray") else {
                return nil
            }
            do {
                let results: [GBLPingResult] = try JSONDecoder().decode([GBLPingResult].self, from: resultData)
                return results
            } catch {
                return nil
            }
        }
        set {
            // just set to nil & return if newValue is nil
            guard newValue != nil else {
                UserDefaults.standard.set(nil, forKey: "GBLPing.ResultArray")
                return
            }
            // handle non-nil updates
            do {
                let resultData = try JSONEncoder().encode(newValue)
                UserDefaults.standard.set(resultData, forKey: "GBLPing.ResultArray")
            } catch {
                #if DEBUG
                print("an unknown error occured while attempting to encode new pingResults array: \(error)")
                #endif
            }
        }
    }
    
    public override init() {
        super.init()
        // recall cached results and store
        // in memory on shared instance as
        // soon as init runs
        pingResults = cachedResults
    }
    
    deinit {
        // save in-memory results to cache
        // before garbage collection or deinit
        cachedResults = pingResults
    }
    
    /// Adds a new result to the cached set of ping results.
    internal func addNewResult(result: GBLPingResult) {
        // handle if results already have been saved
        if var pingResults = pingResults {
            // add latest addition to the front of the array
            pingResults.insert(result, at: 0)
            // update saved value
            self.pingResults = pingResults
            
        // handle if this is the first result
        } else {
            // make new
            var newResults: [GBLPingResult] = []
            // append first
            newResults.append(result)
            // save new results locally
            self.pingResults = newResults
        }
    }
    
    /// Adds a new result to the cached set of ping results.
    internal func updateCurrentresult(result: GBLPingResult) {
        // handle if results already have been saved
        if var pingResults = pingResults {
            // add latest addition to the front of the array
            pingResults.remove(at: 0)
            pingResults.insert(result, at: 0)
            // update saved value
            self.pingResults = pingResults
        // handle if this is the first result
        } else {
            // make new
            var newResults: [GBLPingResult] = []
            // append first
            newResults.append(result)
            // save new results locally
            self.pingResults = newResults
        }
    }
    
    internal func latestResult(for sequenceID: String) -> GBLPingResult {
        // handle if results already have been saved
        if let results = pingResults {
            var newResult = GBLPingResult()
            newResult.sequenceID = self.currentSequenceID
            return results.first ?? newResult
//            // filter by sequenceID
//            let sequenceIDs = results.map { $0.sequenceID }
//            let resultsForSequence = results.filter { sequenceIDs.contains($0.sequenceID) }
//
//            // check results exist
//            if resultsForSequence.count > 0 {
//                // filter by time started
//                let startTimes: [Int] = resultsForSequence.map { ($0.startTime ?? 0) }
//                let max = resultsForSequence.filter { i in startTimes.contains{ i.startTime ?? 0 > $0 } }
//                // return
//                print("latestResult filtered by max: \(max)")
//                return max.first ?? GBLPingResult()
        } else {
            var newResult = GBLPingResult()
            newResult.sequenceID = self.currentSequenceID
            return newResult
        }
//        } else {
//            // if not a match return a new new result
//            return GBLPingResult()
//        }
    }
    // Public & Static functions
    /// Pings a provided hostname
    public func pingHostname(hostname: String) {
        // reset for new operation
        reset(for: hostname)
        
        // Setup simple ping & start
        pinger = SimplePing(hostName: hostname)
        pinger?.delegate = self
        pingerWillStart()
        pinger?.start()
    }
    
    /// Pings a hostname, stopping after the maximum number of pings has been reached.
    public func pingHostname(hostname: String, maxPings: Int) {
        // set max configuration on instance
        self.maxPings = maxPings
        
        // pass-through to hostname ping
        pingHostname(hostname: hostname)
    }
    
    /// Pings a hostname allowing optional ipv4 or ipv6 forcing.
    public func pingHostnameForcing(ipv4: Bool?, ipv6: Bool?, hostname: String) {
        // reset for new operation
        reset(for: hostname)
        
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
        var result = pingResults?.first
        result?.ipv4Forced = ipv4 ?? false
        result?.ipv6Forced = ipv6 ?? false
        
        // setup simple ping & start
        pinger = SimplePing(hostName: hostname)
        pinger?.delegate = self
        pingerWillStart()
        pinger?.start()
    }
    /// Pings a hostname allowing optional ipv4 or ipv6 forcing, stopping after a designated number of pings.
    public func pingHostnameForcing(ipv4: Bool?, ipv6: Bool?, hostname: String, maxPings: Int) {
        // set max configuration on instance
        self.maxPings = maxPings
        // pass-through to basic forcing func
        pingHostnameForcing(ipv4: ipv4, ipv6: ipv6, hostname: hostname)
    }
    /// Resets the result object for a new operation
    private func reset(for host: String){
        // setup / reset the result type for current service operation
        lastPingEventType = .pingReadyToStart
        // setup new squence ID
        self.currentSequenceID = UUID().uuidString
    }
    
    /// Starts the pinging process by either IP or Hostname.
    internal func start(forceIPv4: Bool, forceIPv6: Bool, hostname: String) {
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
    }
    /// Stops the ping service
    internal func stop() {
        pinger?.stop()
        pinger = nil
        pingerDidStop()
        maxPings = nil
        pingAttempts = nil
    }

}

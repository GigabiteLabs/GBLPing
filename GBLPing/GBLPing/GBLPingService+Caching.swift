// GBLPing+Caching.swift
//
// Created by GigabiteLabs on 9/29/20
// Swift Version: 5.0
// Copyright © 2020 GigabiteLabs. All rights reserved.
//

import Foundation

extension GBLPingService {
    
    
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
}

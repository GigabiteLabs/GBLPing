// GBLPing+Caching.swift
//
// Created by GigabiteLabs on 9/29/20
// Swift Version: 5.0
// Copyright © 2020 GigabiteLabs. All rights reserved.
//

import Foundation

extension GBLPingService {

    // TODO: Re-design and refactor this entire caching process
//
//    /// An optional array of `[GBLPingResult]` that has been cached locally, or nil if none has ever been saved.
//    internal var cachedResults: [GBLPingResult]? {
//        get {
//            guard let resultData = UserDefaults.standard.data(forKey: "GBLPing.ResultArray") else {
//                return nil
//            }
//            do {
//                let results: [GBLPingResult] = try JSONDecoder().decode([GBLPingResult].self, from: resultData)
//                return results
//            } catch {
//                return nil
//            }
//        }
//        set {
//            // just set to nil & return if newValue is nil
//            guard newValue != nil else {
//                UserDefaults.standard.set(nil, forKey: "GBLPing.ResultArray")
//                return
//            }
//            // handle non-nil updates
//            do {
//                let resultData = try JSONEncoder().encode(newValue)
//                UserDefaults.standard.set(resultData, forKey: "GBLPing.ResultArray")
//            } catch {
//                #if DEBUG
//                print("an unknown error occured while attempting to encode new pingResults array: \(error)")
//                #endif
//            }
//        }
//    }
//
    /// Adds a new result to the cached set of ping results.
    internal func addNewResult(result: GBLPingResult) {
        currentPingResult = GBLPingResult()
    }

    /// Adds a new result to the cached set of ping results.
    internal func resetPingResult() {
        currentPingResult = GBLPingResult()
    }

    /// Adds a new result to the cached set of ping results.
    internal func updatePingResults(result: GBLPingResult) {
        currentPingResult = result
    }

    internal func latestResult() -> GBLPingResult {
        return currentPingResult ?? GBLPingResult()
    }
}

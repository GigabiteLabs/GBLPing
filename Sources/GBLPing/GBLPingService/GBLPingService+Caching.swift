// GBLPing+Caching.swift
//
// Created by GigabiteLabs on 9/29/20
// Swift Version: 5.0
// Copyright © 2020 GigabiteLabs. All rights reserved.
//

import Foundation

extension GBLPingService {
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

    internal func latestResult() -> GBLPingResult? {
        return currentPingResult
    }
}

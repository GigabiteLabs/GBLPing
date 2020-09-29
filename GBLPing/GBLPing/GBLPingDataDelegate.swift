// GBLPingDataDelegate.swift
//
// Created by GigabiteLabs on 4/14/20
// Swift Version: 5.0
// Copyright © 2020 GigabiteLabs. All rights reserved.
//



import Foundation

public protocol GBLPingDataDelegate {
    /// Called after a ping event completes to provide
    /// the `GBLPingDataDelegate` with a
    /// `GBLPingResult` object created during a ping event.
    ///
    /// - Parameters:
    ///     - result: `GBLPingResult` an object that
    ///     resulted from a successful ping event. This object
    ///     contains metadata about the ping event and it's
    ///     relative position within the ping event sequence.
    ///
    /// - Note: Use error.rawValue to retrieve the error description
    /// string with more detailed error information.
    ///
    /// - Seealso: `GBLPingResult.swift`
    ///
    func gblPingResult(result: GBLPingResult)
}

// ClassConformanceTest.swift
//
// Created by GigabiteLabs on 4/14/20
// Swift Version: 5.0
// Copyright © 2020 GigabiteLabs. All rights reserved.
//

import Foundation
import GBLPing
import XCTest

/// A typealias to enable shorter use
internal typealias Test = GBLPingTestController
/// A shared object that acts as the only central, shared data object
/// between XCTests in this project.
class GBLPingTestController {
    /// A shared static instance of the test controller.
    public static var ctrl = GBLPingTestController()
    /// An array of `GBLPingEvent` objects stored during tests.
    var pingEvents: [GBLPingEvent]?
    /// An array of `GBLPingResult` objects, each
    /// representing a single successful ping.
    var pingResults: [GBLPingResult]?
    /// The last `GBLPingUnexpectedEvent` returned from the service.
    var lastUnexpectedPingEvent: GBLPingUnexpectedEvent?
    /// The last `GBLPingUnexpectedEvent` that returned as an error.
    var lastPingError: GBLPingUnexpectedEvent?
    /// A shared var for ping expectation caching
    var resultExpectation: XCTestExpectation?
    /// Resets all controller variables to nil or empty
    func reset() {
        Test.ctrl.pingEvents = nil
        Test.ctrl.pingResults = nil
        Test.ctrl.lastUnexpectedPingEvent = nil
        Test.ctrl.lastPingError = nil
        Test.ctrl.resultExpectation = nil
        print("\n\nTest.controller successfully reset.\n\n")
    }
}

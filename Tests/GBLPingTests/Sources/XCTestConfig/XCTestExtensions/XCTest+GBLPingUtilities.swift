// File.swift
//
// Created by GigabiteLabs on 9/30/20
// Swift Version: 5.0
// Copyright © 2020 GigabiteLabs. All rights reserved.
//

import Foundation
import XCTest
import GBLPing

public extension XCTestCase {
    /// Asserts that the GBLPing service instance
    /// is configured with the initial / default values
    /// e.g. no tests have run yet
    func assertGBLDefaultConfig() throws {
        // assert delegate assigned
        XCTAssertNotNil(GBLPing.service.delegate, "delegate should not be nil")
        XCTAssertNotNil(GBLPing.service.dataDelegate, "dataDelegate should not be nil")
        // test with above class
        XCTAssertNil(GBLPing.service.currentPingResult, "description should be empty string before a ping is run")
    }
    func resetGBLPingConfig() {
        GBLPing.service.delegate = nil
        GBLPing.service.dataDelegate = nil
    }
    /// Asserts that the Test.controller instance
    /// is configured with the initial / default values
    /// e.g. no tests have run yet
    internal func assertDefaultSpyConfig(spy: GBLPingTestSpyDelegate) {
        XCTAssertNil(spy.pingEvents, "ping events should be nil")
        XCTAssertNil(spy.pingResults, "ping results should be nil")
        XCTAssertNil(spy.lastUnexpectedPingEvent, "lastUnexpectedPingEvent should be nil")
        XCTAssertNil(spy.lastPingError, "lastPingError should be nil")
    }
   internal func assertPingSucceeded(spy: GBLPingTestSpyDelegate) {
        XCTAssertNotNil(spy.pingEvents, "pingEvents cannot be nil if they were successful")
        XCTAssertNotNil(spy.pingResults, "pingResults cannot be nil if they were successful")
        XCTAssertNil(spy.lastPingError, "lastPingError should be nil")
    }
    func executeAsync(id: String, exp: XCTestExpectation) {
        let operation = AsyncOperation { id }
        operation.perform { _ in
            exp.fulfill()
        }
    }
}

// File.swift
//
// Created by GigabiteLabs on 9/29/20
// Swift Version: 5.0
// Copyright © 2020 GigabiteLabs. All rights reserved.
//

import XCTest
import Foundation
import GBLPing

extension XCTest: GBLPingDelegate, GBLPingDataDelegate{
    /// Takes over delegation of `GBLPing`
    func becomeDelegate(selfRef: XCTest) {
        Ping.service.delegate = selfRef
        Ping.service.dataDelegate = selfRef
        print("took delegation of the GBLPing service\n\n")
    }
    /// Asserts that the GBLPing service instance
    /// is configured with the initial / default values
    /// e.g. no tests have run yet
    func assertGBLDefaultConfig() {
        // assert delegate assigned
        XCTAssertNotNil(GBLPing.service.delegate, "delegate should not be nil")
        XCTAssertNotNil(GBLPing.service.dataDelegate, "dataDelegate should not be nil")
        // test with above class
        XCTAssert(GBLPing.service.lastPingEventType == .pingReadyToStart, "event type should be default value")
        XCTAssertNil(GBLPing.service.currentPingResult, "description should be empty string before a ping is run")
    }
    /// Asserts that the Test.controller instance
    /// is configured with the initial / default values
    /// e.g. no tests have run yet
    func assertTestControllerDefaultConfig() {
        XCTAssertNil(Test.ctrl.pingEvents, "ping events should be nil")
        XCTAssertNil(Test.ctrl.pingResults, "ping results should be nil")
        XCTAssertNil(Test.ctrl.lastUnexpectedPingEvent, "lastUnexpectedPingEvent should be nil")
        XCTAssertNil(Test.ctrl.lastPingError, "lastPingError should be nil")
    }
    func assertPingSucceeded() {
        XCTAssertNotNil(Test.ctrl.pingEvents, "pingEvents cannot be nil if they were successful")
        XCTAssertNotNil(Test.ctrl.pingResults, "pingResults cannot be nil if they were successful")
        XCTAssertNil(Test.ctrl.lastPingError, "lastPingError should be nil")
    }
    
    func executeAsync(id: String, exp: XCTestExpectation) {
        let operation = AsyncOperation { id }        
        operation.perform { value in
            exp.fulfill()
        }
    }
    
    public func gblPingEvent(_ event: GBLPingEvent) {
        print("\n********** pingEvent: \(event) **********")
        print("\n********** pingEvent Description: \(event.description) **********")
        guard let _ = Test.ctrl.pingEvents else {
            Test.ctrl.pingEvents = []
            Test.ctrl.pingEvents?.append(event)
            return
        }
        Test.ctrl.pingEvents?.append(event)
    }
    
    public func gblPingUnexpected(event: GBLPingUnexpectedEvent) {
        print("\nunexpectedEventType: \(event.description) **********")
        Test.ctrl.lastUnexpectedPingEvent = event
    }
    
    public func gblPingError(_ error: GBLPingUnexpectedEvent) {
        print("\n********** Ping ERROR: \(error.rawValue) **********")
        Test.ctrl.lastPingError = error
    }
    
    public func gblPingResult(result: GBLPingResult) {
        print("\n********** ping result: \(result) **********")
        guard let _ = Test.ctrl.pingResults else {
            Test.ctrl.pingResults = []
            Test.ctrl.pingResults?.append(result)
            return
        }
        // append to results
        Test.ctrl.pingResults?.append(result)
        // invoke if set
        Test.ctrl.resultExpectation?.fulfill()
    }
}

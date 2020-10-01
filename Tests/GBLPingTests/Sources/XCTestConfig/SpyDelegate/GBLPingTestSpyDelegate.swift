// File.swift
//
// Created by GigabiteLabs on 9/30/20
// Swift Version: 5.0
// Copyright © 2020 GigabiteLabs. All rights reserved.
//

import XCTest
import GBLPing
import Foundation

/// A type of delegate that intercepts &
/// processes delegate calls as an intermediary.
class GBLPingTestSpyDelegate {
    /// An array of `GBLPingEvent` objects stored during tests.
    var pingEvents: [GBLPingEvent]?
    /// An array of `GBLPingResult` objects, each
    /// representing a single successful ping.
    var pingResults: [GBLPingResult]?
    /// The last `GBLPingUnexpectedEvent` returned from the service.
    var lastUnexpectedPingEvent: GBLPingUnexpectedEvent?
    /// The last `GBLPingUnexpectedEvent` that returned as an error.
    var lastPingError: GBLPingUnexpectedEvent?
    /// A flag wehre true means that processes
    /// should run async.
    var processAsync: Bool?
    /// A shared var for ping expectation caching
    var unexpectedEventExpectationt: XCTestExpectation?
    /// A shared var for ping expectation caching
    var eventExpectation: XCTestExpectation?
    /// A shared var for ping expectation caching
    var errorExpectation: XCTestExpectation?
    /// A shared var for ping expectation caching
    var resultExpectation: XCTestExpectation?
    /// Initializes the spy with options.
    public init(_ andBecomePingDelegate: Bool?) {
        if andBecomePingDelegate == true {
            becomeGBLPingDelegate()
        }
    }
}

/// An extension for `GBLPing` protocol conformance.
extension GBLPingTestSpyDelegate: GBLPingDelegate, GBLPingDataDelegate {
    /// Handles events from `GBLPing` events.
    public func gblPingEvent(_ event: GBLPingEvent) {
        print("\n********** Spy: pingEvent Description: \(event.description) **********")
        // cache the event
        if pingEvents == nil {
            pingEvents = []
        }
        // append to results
        pingEvents?.append(event)
        // fulfill the expectation
        eventExpectation?.fulfill()
    }
    /// Handles unexpected events from `GBLPing` events.
    public func gblPingUnexpected(event: GBLPingUnexpectedEvent) {
        print("\n********** Spy: unexpectedEventType Description: \(event.description) **********")
        // cache the event
        lastUnexpectedPingEvent = event

        // fulfill the expectation
        unexpectedEventExpectationt?.fulfill()
    }
    /// Handles errors from `GBLPing` events.
    public func gblPingError(_ error: GBLPingUnexpectedEvent) {
        print("\n********** Spy: pingError Description: \(error.rawValue) **********")
        // cache the error
        lastPingError = error

        // fulfill the expectation
        errorExpectation?.fulfill()
    }
    /// Handles successful responses from `GBLPing` events.
    public func gblPingResult(result: GBLPingResult) {
        print("\n********** Spy: pingResult recievied **********")
        // cache the event
        if pingResults == nil {
            pingResults = []
        }
        // append to results
        pingResults?.append(result)
        // fulfill the expectation
        resultExpectation?.fulfill()
    }
}

extension GBLPingTestSpyDelegate {
    /// Takes delegation responsibility for
    /// `GBLPing` protocols.
    func becomeGBLPingDelegate() {
        Ping.service.delegate = self
        Ping.service.dataDelegate = self
        print("\n\nSpy took delegation of the GBLPing service\n\n")
    }
    /// Sets the `GBLPing` delegates to nil
    func revokeGBLPingDelegates() {
        Ping.service.delegate = nil
        Ping.service.dataDelegate = nil
    }
    /// Resets all stored properties adnd vars to nil
    func reset() {
        pingEvents = nil
        pingResults  = nil
        lastUnexpectedPingEvent = nil
        lastPingError = nil
        processAsync = nil
        unexpectedEventExpectationt = nil
        eventExpectation = nil
        errorExpectation = nil
        resultExpectation = nil
    }
}

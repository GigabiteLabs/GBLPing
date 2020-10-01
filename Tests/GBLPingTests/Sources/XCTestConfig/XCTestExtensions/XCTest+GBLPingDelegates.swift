// File.swift
//
// Created by GigabiteLabs on 9/29/20
// Swift Version: 5.0
// Copyright © 2020 GigabiteLabs. All rights reserved.
//

import XCTest
import Foundation
import GBLPing

//extension XCTest: GBLPingDelegate, GBLPingDataDelegate {
//    
//    public func gblPingEvent(_ event: GBLPingEvent) {
//        print("cached events: \(Test.vars.pingEvents?.toJSONString())")
//        print("\n********** pingEvent Description: \(event.description) **********")
//        guard let _ = Test.vars.pingEvents else {
//            Test.vars.pingEvents = []
//            Test.vars.pingEvents?.append(event)
//            return
//        }
//        Test.vars.pingEvents?.append(event)
//        // call the event result exp
//        Test.vars.eventExpectation?.fulfill()
//    }
//    
//    public func gblPingUnexpected(event: GBLPingUnexpectedEvent) {
//        print("\nunexpectedEventType: \(event.description) **********")
//        Test.vars.lastUnexpectedPingEvent = event
//    }
//    
//    public func gblPingError(_ error: GBLPingUnexpectedEvent) {
//        print("\n********** Ping ERROR: \(error.rawValue) **********")
//        Test.vars.lastPingError = error
//    }
//    
//    public func gblPingResult(result: GBLPingResult) {
//        print("\n********** ping result: \(result) **********")
//        print("cached results: \(Test.vars.pingResults?.toJSONString())")
//        guard let _ = Test.vars.pingResults else {
//            Test.vars.pingResults = []
//            Test.vars.pingResults?.append(result)
//            return
//        }
//        // append to results
//        Test.vars.pingResults?.append(result)
//        // call the optional result exp
//        Test.vars.resultExpectation?.fulfill()
//    }
//}

// ClassConformanceTest.swift
//
// Created by GigabiteLabs on 4/14/20
// Swift Version: 5.0
// Copyright © 2020 GigabiteLabs. All rights reserved.
//

import Foundation
import GBLPingFramework

class GBLPingServiceTestClass: GBLPingServiceProtocol {
    // get shared instance ref
    var gblPing: GBLPing
    // Setup default types
    var lastPingEventType: GBLPingEvent = .pingWillStart
    var lastPingDescription: String = ""
    var lastUnexpectedEvent: GBLPingUnexpectedEvent? = nil
    
    init() {
        // assign reference to shared instance
        gblPing = GBLPing.shared
        gblPing.delegate = self
    }
    
    func gblPingEventDidOccur(event: GBLPingEvent, description: String, unexpectedEventType: GBLPingUnexpectedEvent?) {
        print("pingEvent: \(event.rawValue)")
        print("unexpectedEventType: \(unexpectedEventType?.rawValue ?? "(nil)")")
        print("pingEvent Description: \(description)\n\n")
        
        self.lastPingEventType = event
        self.lastPingDescription = description
        self.lastUnexpectedEvent = unexpectedEventType
    }
}

class GBLPingDelegateTestClass: GBLPingDelegate {
    // Setup default types
    var lastPingEventType: GBLPingEvent = .pingWillStart
    var lastPingDescription: String = ""
    var lastUnexpectedEvent: GBLPingUnexpectedEvent? = nil
    
    init() {
        GBLPing.shared.delegate = self
    }
    
    func gblPingEventDidOccur(event: GBLPingEvent, description: String, unexpectedEventType: GBLPingUnexpectedEvent?) {
        print("pingEvent: \(event.rawValue)")
        print("unexpectedEventType: \(unexpectedEventType?.rawValue ?? "(nil)")")
        print("pingEvent Description: \(description)\n\n")
        
        self.lastPingEventType = event
        self.lastPingDescription = description
        self.lastUnexpectedEvent = unexpectedEventType
    }
}


class GBLPingDataDelegateTestClass: GBLPingDataDelegate {
    init() {
        GBLPing.shared.delegate = self
        GBLPing.shared.dataDelegate = self
    }
    
    func pingResult(result: GBLPingResult) {
        print("ping result")
        print(result)
    }
    
    func gblPingEventDidOccur(event: GBLPingEvent, description: String, unexpectedEventType: GBLPingUnexpectedEvent?) {
        print("\(description)\n")
    }
}

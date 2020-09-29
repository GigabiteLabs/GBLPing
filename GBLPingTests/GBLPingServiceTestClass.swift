// ClassConformanceTest.swift
//
// Created by GigabiteLabs on 4/14/20
// Swift Version: 5.0
// Copyright © 2020 GigabiteLabs. All rights reserved.
//

import Foundation
import GBLPing

class GBLPingTestObject: GBLPingDelegate {
    // Setup default types
    var lastPingDescription: String = ""
    var lastUnexpectedEvent: GBLPingUnexpectedEvent? = nil
    
    init() {
        GBLPing.service.delegate = self
    }
    
    func pingEventOccured(event: GBLPingEvent, description: String, unexpectedEventType: GBLPingUnexpectedEvent?) {
        print("pingEvent: \(event.rawValue)")
        print("unexpectedEventType: \(unexpectedEventType?.rawValue ?? "(nil)")")
        print("pingEvent Description: \(description)\n\n")
        self.lastPingDescription = description
        self.lastUnexpectedEvent = unexpectedEventType
    }
    
    func pingError(error: GBLPingUnexpectedEvent) {
        print("Ping ERROR: \(error.rawValue)")
    }
}


class GBLPingDataTestObject: GBLPingDataDelegate {
    init() {
        GBLPing.service.delegate = self
        GBLPing.service.dataDelegate = self
    }
    
    func pingResult(result: GBLPingResult) {
        print("ping result")
        print(result)
    }
    
    func pingEventOccured(event: GBLPingEvent, description: String, unexpectedEventType: GBLPingUnexpectedEvent?) {
        print("\(description)\n")
    }
    
    func pingError(error: GBLPingUnexpectedEvent) {
        print("Ping ERROR: \(error.rawValue)")
    }
}

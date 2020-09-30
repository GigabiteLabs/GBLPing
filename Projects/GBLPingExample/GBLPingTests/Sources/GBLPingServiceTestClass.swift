// ClassConformanceTest.swift
//
// Created by GigabiteLabs on 4/14/20
// Swift Version: 5.0
// Copyright © 2020 GigabiteLabs. All rights reserved.
//

import Foundation
import GBLPing

class GBLPingTestObject: GBLPingDelegate, GBLPingDataDelegate{
    // Setup default types
    var lastPingDescription: String = ""
    var lastUnexpectedEvent: GBLPingUnexpectedEvent? = nil
    
    init() {
        GBLPing.service.delegate = self
    }
    
    func gblPingEvent(_ event: GBLPingEvent) {
        print("pingEvent: \(event)")
        print("pingEvent Description: \(event.description)\n\n")
    }
    
    func gblPingUnexpected(event: GBLPingUnexpectedEvent) {
        print("unexpectedEventType: \(event.description)")
    }
    
    func gblPingError(_ error: GBLPingUnexpectedEvent) {
        print("Ping ERROR: \(error.rawValue)")
    }
    
    func gblPingResult(result: GBLPingResult) {
        print("ping result: \(result)")
    }
}

// GBLPingDelegate.swift
//
// Created by GigabiteLabs on 4/14/20
// Swift Version: 5.0
// Copyright © 2020 GigabiteLabs. All rights reserved.
//

import Foundation

/// Conforming objects will recieve messages from GBLPing for all service events.
public protocol GBLPingDelegate {
    /// Called when either a success or an unexpected event occured
    ///
    /// - Note: Unexpected events are not necessarily failures, weird stuff sometimes happens with packets during transport.
    /// That being said, an unexpected event is a good time to run some logic to handle these edge cases
    func gblPingEventDidOccur(event: GBLPingEvent, description: String, unexpectedEventType: GBLPingUnexpectedEvent?)
}

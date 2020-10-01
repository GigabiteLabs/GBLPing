// File.swift
//
// Created by GigabiteLabs on 9/30/20
// Swift Version: 5.0
// Copyright © 2020 GigabiteLabs. All rights reserved.
//

import Foundation

extension GBLPingTools: GBLPingDelegate {
    // TODO: Add ping delegate functions to handle tools events
    public func gblPingEvent(_ event: GBLPingEvent) {
        print("ping event: \(event.description)")
    }

    public func gblPingUnexpected(event: GBLPingUnexpectedEvent) {
        print("ping unexpected event: \(event.description)")
    }

    public func gblPingResult(result: GBLPingResult) {
        print("ping result: \(result.toJSONString())")

    }

    public func gblPingError(_ error: GBLPingUnexpectedEvent) {
        print("ping error: \(error.description)")
    }
}

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
internal typealias Test = GBLPingTestEnv
/// A shared object that acts as the only central, shared data object
/// between XCTests in this project.
class GBLPingTestEnv {
    /// A shared static instance of the test controller.
    public static var vars = GBLPingTestEnv()
    /// The default host to use during ping tests
    var defaultPingHost = "ns.cloudflare.com"
}

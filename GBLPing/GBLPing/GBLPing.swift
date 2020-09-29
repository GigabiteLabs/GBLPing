// GBLPing.swift
//
// Created by GigabiteLabs on 4/14/20
// Swift Version: 5.0
// Copyright © 2020 GigabiteLabs. All rights reserved.
//

import Foundation
/// A typealias for simpler consumption.
public typealias Ping = GBLPing
/// The main interface into GBLPing. Initializes a shared instance of the GBLPingService.
public final class GBLPing {
    /// A shared instance of GBLPing
    public static let service = GBLPingService()
    private init() { }
}

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
    /// A shared instance of GBLPing to be used
    /// or shared among multiple views or objects.
    ///
    /// - Note: This shared instance retains values
    /// in between usage. So long as it is not deallocated,
    /// the data from a prior ping session will be available
    /// to another object without having to invoke another
    /// ping session.
    ///
    public static let service = GBLPingService()
    /// A computed property that returns a new instance of
    /// `GBLPingService` that can be deallocated after use.
    public static var serviceInstance: GBLPingService {
        return GBLPingService()
    }
    /// A computed property that returns a new instance of
    /// `GBLPingTools`.
    public static var tools: GBLPingTools {
        return GBLPingTools()
    }
    ///
    private init() { }
}

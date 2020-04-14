// GBLPing.swift
//
// Created by GigabiteLabs on 4/14/20
// Swift Version: 5.0
// Copyright © 2020 GigabiteLabs. All rights reserved.
//

import Foundation
/// The main interface into GBLPing. Initializes a shared instance of the GBLPingService.
public class GBLPing: GBLPingService {
    /// A shared instance of GBLPing
    public static let shared = GBLPing()
    private override init() { }
}

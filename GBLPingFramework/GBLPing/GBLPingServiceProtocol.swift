// GBLPingServiceProtocol.swift
//
// Created by GigabiteLabs on 4/14/20
// Swift Version: 5.0
// Copyright © 2020 GigabiteLabs. All rights reserved.
//

import Foundation
/// Conforming objects will recieve service event data, but will also
/// maintain a local refernce to the GBLPing shared instance
public protocol GBLPingServiceProtocol: GBLPingDelegate {
    /// A localized reference to GBLPing
    var gblPing: GBLPing { get set }
}

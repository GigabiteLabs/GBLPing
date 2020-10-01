// File.swift
//
// Created by GigabiteLabs on 9/30/20
// Swift Version: 5.0
// Copyright © 2020 GigabiteLabs. All rights reserved.
//

import Foundation

extension GBLPingService {
    internal func handleCompletion(event: GBLPingEvent, result: GBLPingResult?) {
        guard let completion = cache.pingHostCompletion else { return }
        completion(event, result)
    }
}

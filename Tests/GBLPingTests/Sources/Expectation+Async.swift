// File.swift
//
// Created by GigabiteLabs on 9/30/20
// Swift Version: 5.0
// Copyright © 2020 GigabiteLabs. All rights reserved.
//

import Foundation
import XCTest

// TODO: Replace with expectation
public struct AsyncOperation<Value> {
    let queue: DispatchQueue = .main
    let closure: () -> Value
    
    func perform(then handler: @escaping (Value) -> Void) {
        queue.async {
            let value = self.closure()
            handler(value)
        }
    }
}

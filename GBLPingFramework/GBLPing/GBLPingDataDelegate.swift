// GBLPingDataDelegate.swift
//
// Created by GigabiteLabs on 4/14/20
// Swift Version: 5.0
// Copyright © 2020 GigabiteLabs. All rights reserved.
//



import Foundation

public protocol GBLPingDataDelegate: GBLPingDelegate {
    func pingResult(result: GBLPingResult)
}

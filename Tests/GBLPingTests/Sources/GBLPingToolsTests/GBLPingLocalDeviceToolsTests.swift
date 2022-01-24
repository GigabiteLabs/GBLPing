// File.swift
//
// Created by GigabiteLabs on 10/1/20
// Swift Version: 5.0
// Copyright © 2020 GigabiteLabs. All rights reserved.
//

import Foundation


import Foundation
import XCTest
import GBLPing

class GBLPingToolsDeviceTests: XCTestCase {

    override func setUpWithError() throws {
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }

    override func tearDownWithError() throws {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
    }

    func test1GetLocalInterfacePointers() {
        guard
            let interfaces = Ping.localDevice.interfaces,
            interfaces.count > 0
        else {
            XCTFail("local device interfaces should not be null")
            return
        }
    }
    
    func test2GetLocalInterfaceNames() {
        guard
            let names = Ping.localDevice.interfaceNames,
            names.count > 0
        else {
            XCTFail("local device interface names should not be null")
            return
        }
    }
    
    func test3GetLocalInterfaceInfo() {
        guard
            let _ = Ping.localDevice.networkInfoFor(localInterface: .wifi)
        else {
            XCTFail("local device interface names should not be null")
            return
        }
    }
}

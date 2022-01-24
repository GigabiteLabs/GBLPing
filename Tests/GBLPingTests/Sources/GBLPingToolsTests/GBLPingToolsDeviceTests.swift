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
        if let interfaces = Ping.localDevice.interfaces {
            for interface in interfaces {
                print("ifa_addr: \(String(describing: interface.ifa_addr))")
            }
        } else {
            XCTFail("local device interfaces should not be null")
        }
    }
    
    func test2GetLocalInterfaceNames() {
        if let names = Ping.localDevice.interfaceNames {
            for name in names {
                print("interface name: \(name)")
            }
        } else {
            XCTFail("local device interface names should not be null")
        }
    }
    
    func test3GetLocalInterfaceInfo() {
        if let networkInfo = Ping.localDevice.networkInfoFor(localInterface: .wifi) {
            print("local device info:")
            print(networkInfo)
        } else {
            XCTFail("local device interface names should not be null")
        }
    }
}

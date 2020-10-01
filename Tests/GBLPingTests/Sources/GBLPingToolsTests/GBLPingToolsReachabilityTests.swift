// File.swift
//
// Created by GigabiteLabs on 9/30/20
// Swift Version: 5.0
// Copyright © 2020 GigabiteLabs. All rights reserved.
//

import Foundation
import XCTest
import GBLPing

class GBLPingToolsReachabilityTests: XCTestCase {

    override func setUpWithError() throws {
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }

    override func tearDownWithError() throws {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
    }

    func testReachability() {
        let exp = expectation(description: "the internet should be reachable")

        GBLPing.tools.internet.reachable { (reachable) in
            print("internet reachable: \(reachable)")
            if reachable {
                XCTAssertTrue(reachable)
                exp.fulfill()
            }
        }
        wait(for: [exp], timeout: 5)
    }

    func testPerformance() {
        self.measure {
            testReachability()
        }
    }
}

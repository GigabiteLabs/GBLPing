// GBLPingFrameworkTests.swift
//
// Created by GigabiteLabs on 4/14/20
// Swift Version: 5.0
// Copyright © 2020 GigabiteLabs. All rights reserved.
//

import XCTest
import GBLPing

class GBLPingFrameworkTests: XCTestCase {

    override func setUpWithError() throws {
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }

    override func tearDownWithError() throws {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
    }
    
    func test_1_GBLPingDelegateClass(){
        print("\n\n************ Testing GBLPingDelegate ************")
        becomeDelegate(selfRef: self)
        assertGBLDefaultConfig()
        assertTestControllerDefaultConfig()
        
        let exp = expectation(description: "a single ping should succeed")
        executeAsync(id: #function, exp: exp)
        
        GBLPing.service.pingHostname(hostname: "ns.cloudflare.com")
        wait(for: [exp], timeout: 10)
    }
    
//    func test_2_GBLDataDelegate(){
//        print("\n\n************ Testing GBLDataDelegate ************")
//        // setup new test class
//        let dataDelegate = GBLPingTestObject()
//
//        // assert delegate assigned
//        XCTAssertNotNil(GBLPing.service.delegate, "delegate should not be nil, shoudl be automatically claimed by test class")
//
//        // test with above class
//        XCTAssert(GBLPing.service.lastPingEventType == .pingReadyToStart, "event type should indicate that event has already occured")
//        XCTAssert(dataDelegate.lastPingDescription == "", "description should be empty string before a ping is run")
//
//        // ping
//        GBLPing.service.pingHostname(hostname: "developer.gigabitelabs.com")
//
//        // re-run, measuring performance
//        self.measure {
//            test_2_GBLDataDelegate()
//        }
//    }
}

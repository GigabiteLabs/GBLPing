// GBLPingOperationsTests.swift
//
// Created by GigabiteLabs on 5/8/20
// Swift Version: 5.0
// Copyright © 2020 GigabiteLabs. All rights reserved.
//

import XCTest
import GBLPing

class GBLPingOperationsTests: XCTestCase {

    override func setUpWithError() throws {
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }

    override func tearDownWithError() throws {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
    }

//    func test_1_TestMaxPingEvents() throws {
//        print("\n\n************ TestMaxPingEvents ************")
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
//        // ping with maximum specifier
//        GBLPing.service.pingHostname(hostname: "gigabitelabs.com", maxPings: 10)
//        
//        // create an async operation with pingHostname
//        // TODO: Replace with expectation
//        let operation = AsyncOperation { GBLPing.service.pingHostname(hostname: "gigabitelabs.com") }
//        let expectation = self.expectation(description: "pinging a hostname should succeed")
//
//        // perform the operation
//        operation.perform { value in
//            sleep(10)
//            expectation.fulfill()
//        }
//
//        // expect a return within 10 seconds
//        waitForExpectations(timeout: 30)
//        
////        // This is an example of a performance test case.
////        self.measure {
////            // Put the code you want to measure the time of here.
////        }
//    }

}

// GBLPingFrameworkTests.swift
//
// Created by GigabiteLabs on 4/14/20
// Swift Version: 5.0
// Copyright © 2020 GigabiteLabs. All rights reserved.
//

import XCTest
import GBLPing

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

class GBLPingFrameworkTests: XCTestCase {

    override func setUpWithError() throws {
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }

    override func tearDownWithError() throws {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
    }
    
    func test_1_GBLPingDelegateClass(){
        print("\n\n************ Testing GBLPingDelegate ************")
        // setup new test class
        let delegateTest = GBLPingTestObject()
        
        // assert delegate assigned
        XCTAssertNotNil(GBLPing.service.delegate, "delegate should not be nil, shoudl be automatically claimed by test class")
        
        // test with above class
        XCTAssert(GBLPing.service.lastPingEventType == .pingReadyToStart, "event type should indicate that event has already occured")
        XCTAssert(delegateTest.lastPingDescription == "", "description should be empty string before a ping is run")
        
        // create an async operation with pingHostname
        let operation = AsyncOperation { GBLPing.service.pingHostname(hostname: "developer.gigabitelabs.com") }
        let expectation = self.expectation(description: "pinging a hostname should succeed")

        // perform the operation
        operation.perform { value in
            expectation.fulfill()
        }

        // expect a return within 10 seconds
        waitForExpectations(timeout: 10)
        
        // test outcome
        
        // ping
        GBLPing.service.pingHostname(hostname: "developer.gigabitelabs.com")
    }
    
    func test_2_GBLDataDelegate(){
        print("\n\n************ Testing GBLDataDelegate ************")
        // setup new test class
        let dataDelegate = GBLPingTestObject()
        
        // assert delegate assigned
        XCTAssertNotNil(GBLPing.service.delegate, "delegate should not be nil, shoudl be automatically claimed by test class")
        
        // test with above class
        XCTAssert(GBLPing.service.lastPingEventType == .pingReadyToStart, "event type should indicate that event has already occured")
        XCTAssert(dataDelegate.lastPingDescription == "", "description should be empty string before a ping is run")
        
        // ping
        GBLPing.service.pingHostname(hostname: "developer.gigabitelabs.com")
        
        // re-run, measuring performance
        self.measure {
            test_2_GBLDataDelegate()
        }
    }
}

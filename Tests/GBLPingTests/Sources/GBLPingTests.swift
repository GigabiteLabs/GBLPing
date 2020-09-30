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
    
    func test1GBLPingDelegateClass() {
        print("\n\n************ \(#function) ************")
        becomeDelegate(selfRef: self)
        assertGBLDefaultConfig()
        assertTestControllerDefaultConfig()
        
        let exp = expectation(description: "a single ping should succeed")
        executeAsync(id: #function, exp: exp)
        
        GBLPing.service.pingHostname(hostname: "ns.cloudflare.com")
        wait(for: [exp], timeout: 10)
    }
    
    func test2GBLDataDelegate() {
        print("\n\n************ \(#function) ************")
        let exp = expectation(description: "a single ping should succeed")
        executeAsync(id: #function, exp: exp)
        
        // ping
        GBLPing.service.pingHostname(hostname: "ns.cloudflare.com")
        wait(for: [exp], timeout: 10)
    }
    
    func test3MaxPingAttempts() {
        print("\n\n************ \(#function) ************")
        // max attempts
        let maxAttempts = 8
        let exp = expectation(description: "a single ping should succeed")
        exp.expectedFulfillmentCount = maxAttempts
        Test.ctrl.eventExpectation = exp
        //executeAsync(id: #function, exp: exp)
        
        // ping
        GBLPing.service.pingHostname(hostname: Test.ctrl.defaultPingHost, maxPings: maxAttempts)
        wait(for: [Test.ctrl.eventExpectation!], timeout: 10)
        
        print(Test.ctrl.pingResults?.toJSONString(options: .prettyPrinted))
        XCTAssertEqual(Test.ctrl.pingResults?.count, maxAttempts)
    }
    
    func testPerformance() throws {
        self.measure {
            resetGBLPingConfig()
            Test.ctrl.reset()
            test1GBLPingDelegateClass()
            test2GBLDataDelegate()
        }
    }
}

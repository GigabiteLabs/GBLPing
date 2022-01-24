// GBLPingFrameworkTests.swift
//
// Created by GigabiteLabs on 4/14/20
// Swift Version: 5.0
// Copyright © 2020 GigabiteLabs. All rights reserved.
//

import XCTest
import GBLPing

class GBLPingServiceTests: XCTestCase {

    override func setUpWithError() throws {
    }

    override func tearDownWithError() throws {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
    }

    func testMaxPingAttempts_DefaultHostname() {
        print("\n\n************ \(#function) ************")
        // configure the max number
        // of ping attempts this test
        // should allow
        let maxAttempts = 8
        // setup the spy object
        let spy: GBLPingTestSpyDelegate = .init(true)
        spy.becomeGBLPingDelegate()
        // set an expectation
        // on the spy
        spy.resultExpectation = XCTestExpectation(description: "a specified number of attempts should match expectation fulfillments")
        spy.resultExpectation?.expectedFulfillmentCount = maxAttempts

        print("spy resultExpectation.expectedFulfillmentCount: \(spy.resultExpectation?.expectedFulfillmentCount ?? 00)")

        // start ping service
        GBLPing.svc.pingHostname(hostname: Test.vars.defaultPingHost,
                                     maxPings: maxAttempts) { (result) in
            XCTAssertTrue(result)
        }
        wait(for: [spy.resultExpectation!], timeout: 15)

        // test that the delgate
        // recieved the right number of results
        XCTAssertEqual(spy.pingResults?.count, maxAttempts)
        XCTAssertNotNil(spy.pingEvents)
        
        spy.reset()
    }
    
    func testReachability_completion() {
        print("\n\n************ \(#function) ************")
        let reachableExp = XCTestExpectation(description: "a completion handler should be called if network is reachable")
        Ping.network.isReachable { reachable in
            XCTAssertTrue(reachable)
            reachableExp.fulfill()
        }
        wait(for: [reachableExp], timeout: 15)
    }
}

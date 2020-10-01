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

    func testMaxPingAttempts_Delegate() {
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
        GBLPing.service.pingHostname(hostname: Test.vars.defaultPingHost,
                                     maxPings: maxAttempts) { (_, result) in
            print(result?.toJSONString(options: .prettyPrinted) ?? "\n")
        }
        wait(for: [spy.resultExpectation!], timeout: 15)

        // test that the delgate
        // recieved the right number of results
        XCTAssertEqual(spy.pingResults?.count, maxAttempts)
        XCTAssertNotNil(spy.pingEvents)
    }

    func testMaxPingAttempts_CompletionHandler() {
        print("\n\n************ \(#function) ************")
        // configure the max number
        // of ping attempts this test
        // should allow
        let maxAttempts = 8
        let exp = XCTestExpectation(description: "a specified number of attempts should match expectation fulfillments")
        exp.expectedFulfillmentCount = maxAttempts

        // var to track the number of
        // completion handler calls
        // from 1 so not undercounted
        var events: [GBLPingEvent] = []
        var results: [GBLPingResult] = []
        // start ping service
        GBLPing.service.pingHostname(hostname: Test.vars.defaultPingHost,
                                     maxPings: maxAttempts) { (event, result) in
            print(result?.toJSONString(options: .prettyPrinted) ?? "\n")

            // this function will
            // be called on every event
            switch event {
            case .responsePacketRecieved:
                // so only process if
                // result is non-nil
                if let result = result  {
                    results.append(result)
                    exp.fulfill()
                }
            default:
                events.append(event)
            }

        }
        // wait for fulfillment attempts
        wait(for: [exp], timeout: 15)

        // test that the completion
        // handler returned the correct
        // number of results
        XCTAssertEqual(results.count, maxAttempts)
    }

    func testPerformance() throws {
        self.measure {
            testMaxPingAttempts_Delegate()
            testMaxPingAttempts_CompletionHandler()
        }
    }
}

// File.swift
//
// Created by GigabiteLabs on 9/30/20
// Swift Version: 5.0
// Copyright © 2020 GigabiteLabs. All rights reserved.
//

import Foundation

import XCTest
import GBLPing

class GBLPingServiceProtocolTests: XCTestCase {

    override func setUpWithError() throws {
    }

    override func tearDownWithError() throws {
    }

    func test1GBLPingDelegateProtocols() {
        print("\n\n************ \(#function) ************")
        // setup the spy object
        let spy: GBLPingTestSpyDelegate = .init(true)
        // set an expectation
        // on the spy
        spy.resultExpectation = XCTestExpectation(description: "a single ping should succeed")

        // this is the first test, so we
        // assert default configurations
        assertDefaultSpyConfig(spy: spy)

        // start the pinging service
        GBLPing.svc.pingHostname(hostname: "ns.cloudflare.com", nil)

        // await fulfillment
        wait(for: [spy.resultExpectation!], timeout: 10)

        // assert valid completion
        XCTAssertNotNil(spy.pingEvents)
        XCTAssertNotNil(spy.pingResults)
    }
}

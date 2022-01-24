//// File.swift
////
//// Created by GigabiteLabs on 9/30/20
//// Swift Version: 5.0
//// Copyright © 2020 GigabiteLabs. All rights reserved.
////
//
//import Foundation
//import XCTest
//import GBLPing
//
//class GBLPingToolsReachabilityTests: XCTestCase {
//
//    override func setUpWithError() throws {
//        // Put setup code here. This method is called before the invocation of each test method in the class.
//    }
//
//    override func tearDownWithError() throws {
//        // Put teardown code here. This method is called after the invocation of each test method in the class.
//    }
//
//    func testReachabilityCompletion() {
//        let exp = self.expectation(description: "the internet should be reachable")
//        exp.expectedFulfillmentCount = 10
//        GBLPing.tools.internet.reachable { (reachable) in
//            print("internet reachable: \(reachable)")
//            if reachable {
//                XCTAssertTrue(reachable)
//                exp.fulfill()
//            }
//        }
//        wait(for: [exp], timeout: 40)
//    }
//    
//    func testReachabilityDelegate() {
//        // setup the spy object
//        let spy: GBLPingTestSpyDelegate = .init(true)
//        spy.becomeGBLPingDelegate()
//        // setup expectation
//        let exp = self.expectation(description: "the internet should be reachable")
//        exp.expectedFulfillmentCount = 10
//        spy.resultExpectation = exp
//        
//        // test rechability
//        Ping.tools.internet.reachable()
//        
//        wait(for: [spy.resultExpectation!], timeout: 40)
//    }
//
////    func testPerformance() {
////        self.measure {
////            testReachability()
////        }
////    }
//}

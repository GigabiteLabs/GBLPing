// GBLPingFrameworkTests.swift
//
// Created by GigabiteLabs on 4/14/20
// Swift Version: 5.0
// Copyright © 2020 GigabiteLabs. All rights reserved.
//

import XCTest
import GBLPingFramework

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

    func testGBLPingServiceClass() throws {
        // setup initial test class
        let serviceTest = GBLPingServiceTestClass()
        sleep(1)
        
        XCTAssert(GBLPing.shared.delegate != nil,
                  "GBLPing delegate should not be nil")
//        XCTAssert(type(of: GBLPing.shared.delegate.self) == GBLPingServiceTestClass.self,
//                  "current GBLPing.shared delegate should be current test class")
        
        // test with above class
        XCTAssert(serviceTest.lastPingEventType != .pingWillStart, "event type should indicate that event has already occured")
        XCTAssert(serviceTest.lastPingDescription != "", "every event should return a description")
        
        GBLPing.shared.pingHostname(hostname: "developer.gigabitelabs.com")
    }
    
    func testGBLPingDelegateClass(){
        // setup new test class
        let delegateTest = GBLPingDelegateTestClass()
        
        XCTAssert(GBLPing.shared.delegate != nil,
                  "GBLPing delegate should not be nil")
        XCTAssert(type(of: GBLPing.shared.delegate.self) == GBLPingDelegateTestClass.self,
                  "current GBLPing.shared delegate should be current test class")
        
        // test with above class
    
        XCTAssert(delegateTest.lastPingEventType != .pingWillStart, "event type should indicate that event has already occured")
        XCTAssert(delegateTest.lastPingDescription != "", "every event should return a description")
        
        GBLPing.shared.pingHostname(hostname: "developer.gigabitelabs.com")
        // Given
        let operation = AsyncOperation { "Ping GBL" }
        let expectation = self.expectation(description: #function)
        var result: String?

        // When
        operation.perform { value in
            result = value
            expectation.fulfill()
        }

        // Then
        waitForExpectations(timeout: 10)
        XCTAssertEqual(result, "Hello, world!")
        
        GBLPing.shared.pingHostname(hostname: "developer.gigabitelabs.com")
        GBLPing.shared.pingHostnameForcing(ipv4: true, ipv6: true, hostname: "developer.gigabitelabs.com")
        GBLPing.shared.pingHostnameForcing(ipv4: true, ipv6: nil, hostname: "developer.gigabitelabs.com")
    }
    
    func testGBLDataDelegate(){
        print("testing data delegate")
        let dataDelegate = GBLPingDelegateTestClass()
        
        GBLPing.shared.pingHostname(hostname: "developer.gigabitelabs.com")
        sleep(1)
        //GBLPing.shared.pingHostnameForcing(ipv4: true, ipv6: true, hostname: "developer.gigabitelabs.com")
        //GBLPing.shared.pingHostnameForcing(ipv4: true, ipv6: nil, hostname: "developer.gigabitelabs.com")
    }

    func testPerformanceExample() throws {
        // This is an example of a performance test case.
        self.measure {
             let _ = GBLPingDelegateTestClass()
            GBLPing.shared.pingHostname(hostname: "developer.gigabitelabs.com")
            let _ = GBLPingServiceTestClass()
            GBLPing.shared.pingHostname(hostname: "developer.gigabitelabs.com")
        }
    }
}

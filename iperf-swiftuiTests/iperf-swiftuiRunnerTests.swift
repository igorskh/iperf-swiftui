//
//  iperf3_runnerTests.swift
//  iperf3-swiftTests
//
//  Created by Igor Kim on 08.11.20.
//

import XCTest

@testable import iperf_swiftui

import IperfSwift

class iperf3_runnerTests: XCTestCase {
    private var runner: IperfRunner = IperfRunner()
    private var formInput: IperfConfigurationInput = IperfConfigurationInput(address: "127.0.0.1")

    override func setUpWithError() throws {
        let config = IperfConfiguration(formInput)
        runner = IperfRunner(with: config)
    }

    override func tearDownWithError() throws {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
    }

    func testRunFailed() throws {
        var results: [IperfIntervalResult] = []
        
        runner.start { result in
            results.append(result)
        }
        
        let result = XCTWaiter.wait(for: [expectation(description: "Running iPerf3 Client")], timeout: 2.0)
        if result == XCTWaiter.Result.timedOut {
            XCTAssert(results.count > 2)
            XCTAssertEqual(results[2].hasError, true)
            XCTAssertEqual(results[2].error, .IESENDMESSAGE)
        } else {
            XCTFail("Delay interrupted")
        }
    }
}

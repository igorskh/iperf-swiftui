//
//  iperf3_swiftTests.swift
//  iperf3-swiftTests
//
//  Created by Igor Kim on 07.11.20.
//

import XCTest

@testable import iperf3_swift

import IperfSwift

class iperf3_swiftTests: XCTestCase {
    private var formInput: IperfConfigurationInput = IperfConfigurationInput(address: "127.0.0.1")

    override func setUpWithError() throws {
        formInput = IperfConfigurationInput(address: "127.0.0.1")
    }

    override func tearDownWithError() throws {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
    }
    
    func testRateOptions() throws {
        var t = StringWithOption<RateOption>(value: "5", option: .Mbps, optionIndex: 0)
        XCTAssertEqual(t.option.description, "Mbps")
        
        t = StringWithOption<RateOption>(value: "5", option: .Gbps, optionIndex: 0)
        XCTAssertEqual(t.option.description, "Gbps")

        t = StringWithOption<RateOption>(value: "1", option: .Kbps, optionIndex: 0)
        XCTAssertEqual(t.option.description, "Kbps")
        XCTAssertNil(t.option.uiImage)
    }
    
    func testConfigConversion() throws {
        formInput.duration = "5"
        formInput.nofStreams = "2"
        formInput.port = "5202"
        
        var configuration = IperfConfiguration(formInput)
        XCTAssertEqual(configuration.address, "127.0.0.1")
        XCTAssertEqual(configuration.duration, 5.0)
        XCTAssertEqual(configuration.numStreams, 2)
        XCTAssertEqual(configuration.port, 5202)
        XCTAssertEqual(configuration.rate, 1024*1024)
        
        formInput.rate = StringWithOption<RateOption>(value: "5", option: .Mbps, optionIndex: 0)
        configuration = IperfConfiguration(formInput)
        XCTAssertEqual(configuration.rate, 5*1024*1024)
        
        formInput.rate = StringWithOption<RateOption>(value: "4", option: .Kbps, optionIndex: 0)
        configuration = IperfConfiguration(formInput)
        XCTAssertEqual(configuration.rate, 4*1024)
        
        formInput.rate = StringWithOption<RateOption>(value: "1", option: .Gbps, optionIndex: 0)
        configuration = IperfConfiguration(formInput)
        XCTAssertEqual(configuration.rate, 1*1024*1024*1024)
    }

    func testRateOutput() throws {
        struct TpTestCase {
            var id = UUID()
            var bytes: UInt64
            var seconds: Double
            var bytesPerSecond: Double {
                Double(bytes) / seconds
            }
            var pretty: String
        }
        let cases: [TpTestCase] = [
            TpTestCase(bytes: 1000, seconds: 10, pretty: "800.0 bps"),
            TpTestCase(bytes: 1000, seconds: 1, pretty: "7.8 Kbps"),
            TpTestCase(bytes: 1000, seconds: 2, pretty: "3.9 Kbps"),
            TpTestCase(bytes: 2000000, seconds: 1, pretty: "15.3 Mbps"),
            TpTestCase(bytes: 2000000000, seconds: 1, pretty: "14.9 Gbps")
        ]
        
        cases.forEach { c in
            let tp1 = IperfThroughput(bytes: c.bytes, seconds: c.seconds)
            let tp2 = IperfThroughput(bytesPerSecond: c.bytesPerSecond)
            
            XCTAssertEqual(tp1.rawValue, tp2.rawValue)
            XCTAssertEqual(tp1.bps, tp2.bps)
            XCTAssertEqual(tp1.Kbps, tp2.Kbps)
            XCTAssertEqual(tp1.Mbps, tp2.Mbps)
            XCTAssertEqual(tp1.Gbps, tp2.Gbps)
            
            XCTAssertEqual(tp1.bps, c.bytesPerSecond*8)
            XCTAssertEqual(tp1.Kbps, c.bytesPerSecond/1024*8)
            XCTAssertEqual(tp1.Mbps, c.bytesPerSecond/1024/1024*8)
            XCTAssertEqual(tp1.Gbps, c.bytesPerSecond/1024/1024/1024*8)

            XCTAssertEqual(tp1.pretty, c.pretty)
        }
    }
}

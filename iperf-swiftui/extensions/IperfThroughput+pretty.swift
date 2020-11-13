//
//  IperfThroughput+pretty.swift
//  iperf-swiftui
//
//  Created by Igor Kim on 10.11.20.
//

import Foundation

import IperfSwift

extension IperfThroughput {
    func pretty(format: String = "%.1f") -> String {
        if bps <= 1024 {
            return "\(String(format: format, bps)) bps"
        }
        if Kbps <= 1024 {
            return "\(String(format: format, Kbps)) Kbps"
        }
        if Mbps <= 1024 {
            return "\(String(format: format, Mbps)) Mbps"
        }
        return "\(String(format: format, Gbps)) Gbps"
    }
}

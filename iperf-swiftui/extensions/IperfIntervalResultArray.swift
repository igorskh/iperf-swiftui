//
//  IperfIntervalResultArray.swift
//  iperf-swiftui
//
//  Created by Igor Kim on 10.11.20.
//

import Foundation

import IperfSwift

extension Array where Element == IperfIntervalResult {
    func relativeTimeDifference() -> [(Double, Double)] {
        self.map { e in (e.startTime - self.first!.startTime, e.endTime - self.first!.startTime) }
    }
}

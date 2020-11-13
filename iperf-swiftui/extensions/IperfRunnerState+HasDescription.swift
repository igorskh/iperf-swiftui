//
//  IperfRunnerState+HasDescription.swift
//  iperf-swiftui
//
//  Created by Igor Kim on 10.11.20.
//

import Foundation

import IperfSwift

extension IperfRunnerState: HasDescription {
    var description: String {
        switch self {
        case .unknown:
            return "N/A"
        case .ready:
            return "Ready"
        case .initialising:
            return "Initialising..."
        case .running:
            return "Running..."
        case .error:
            return "Failed"
        case .stopping:
            return "Stopping..."
        case .finished:
            return "Finished"
        }
    }
    
    var uiImage: String? {
        nil
    }
}

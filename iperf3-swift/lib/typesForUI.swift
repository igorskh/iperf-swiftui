//
//  typesForUI.swift
//  iperf3-swift
//
//  Created by Igor Kim on 28.10.20.
//

import Foundation

struct IperfConfigurationInput {
    var address: String
    var port: String = "5201"
    var duration: String = "5"
    var tos: String = "0"
    var nofStreams: String = "1"
    var reportInterval: String = "1"
    
    var role: IperfRole = .client
    var direction: IperfDirection = .download
}

extension IperfConfiguration {
    init(_ input: IperfConfigurationInput) {
        address = input.address
        role = input.role
        reverse = input.direction
        
        if let v = Int(input.port) {
            port = v
        }
        if let v = Double(input.duration) {
            duration = v
        }
        if let v = Int(input.tos) {
            tos = v
        }
        if let v = Int(input.nofStreams) {
            numStreams = v
        }
        if let v = Double(input.reportInterval) {
            reporterInterval = v
        }
    }
}

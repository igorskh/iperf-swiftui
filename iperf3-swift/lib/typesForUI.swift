//
//  typesForUI.swift
//  iperf3-swift
//
//  Created by Igor Kim on 28.10.20.
//

import Foundation

protocol TextFieldOption: HasDescription {
    var rawValue: String { get }
}

struct StringWithOption<T> {
    var value: String
    var option: T
    var optionIndex: Int
}

enum RateOption: TextFieldOption {
    case Kbps
    case Mbps
    case Gbps
    
    var rawValue: String {
        switch self {
        case .Kbps:
            return "Kbps"
        case .Mbps:
            return "Mbps"
        case .Gbps:
            return "Gbps"
        }
    }
    var uiImage: String? {
        return nil
    }
    var description: String {
        return rawValue
    }
}

struct IperfConfigurationInput {
    var address: String
    var port: String = "5201"
    var duration: String = "5"
    var tos: String = "0"
    var nofStreams: String = "1"
    var rate: StringWithOption<RateOption> = StringWithOption<RateOption>(value: "1", option: .Mbps, optionIndex: 1)
    var reportInterval: String = "1"
    
    var prot: IperfProtocol {
        protocolOptions[protocolIndex]
    }
    var role: IperfRole {
        roleOptions[roleIndex]
    }
    var direction: IperfDirection {
        directionOptions[directionIndex]
    }
    
    var roleOptions: [IperfRole] = [.client, .server]
    var directionOptions: [IperfDirection] = [.download, .upload]
    var protocolOptions: [IperfProtocol] = [.tcp, .udp]
    
    var protocolIndex: Int = 0
    var roleIndex: Int = 0
    var directionIndex: Int = 0
}

extension IperfConfiguration {
    init(_ input: IperfConfigurationInput) {
        address = input.address
        role = input.role
        reverse = input.direction
        prot = input.prot
        
        if let v = UInt64(input.rate.value) {
            rate = v
            if input.rate.option == .Kbps {
                rate *= 1024
            } else if input.rate.option == .Mbps {
                rate *= 1024*1024
            } else if input.rate.option == .Gbps {
                rate *= 1024*1024*1024
            }
        }
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

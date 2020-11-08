//
//  RateOption.swift
//  iperf3-swift
//
//  Created by Igor Kim on 08.11.20.
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

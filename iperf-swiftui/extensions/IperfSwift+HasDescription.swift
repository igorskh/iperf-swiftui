//
//  types.swift
//  iperf3-swift
//
//  Created by Igor Kim on 28.10.20.
//

import Foundation

import IperfSwift

protocol HasDescription {
    var description: String { get }
    var uiImage: String? { get }
}

extension IperfProtocol: HasDescription {
    var uiImage: String? {
        return nil
    }
    var description: String {
        switch self {
        case .tcp:
            return "TCP"
        case .udp:
            return "UDP"
        case .sctp:
            return "SCTP"
        }
    }
}

extension IperfRole: HasDescription {
    var uiImage: String? {
        return nil
    }
    var description: String {
        switch self {
        case .client:
            return "Client"
        case .server:
            return "Server"
        }
    }
}

extension IperfDirection: HasDescription {
    var uiImage: String? {
        switch self {
        case .download:
            return "arrow.down"
        case .upload:
            return "arrow.up"
        }
    }
    var description: String {
        switch self {
        case .download:
            return "Download"
        case .upload:
            return "Upload"
        }
    }
}

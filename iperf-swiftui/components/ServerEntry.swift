//
//  ServerEntry.swift
//  iperf-swiftui
//
//  Created by Igor Kim on 09.11.20.
//

import Foundation

enum ServerEntryType: String, Codable, HasDescription {
    var description: String {
        switch self {
        case .localServer:
            return "Local"
        case .publicServer:
            return "Public"
        case .listenOn:
            return "Listen"
        }
    }
    
    var uiImage: String? {
        return nil
    }
    
    case localServer = "local"
    case publicServer = "public"
    case listenOn = "listen"
}

struct ServerPortsEntry: Codable {
    let tcp: [String]?
    let udp: [String]?
}

struct ServerPortsEntryParsed: Codable {
    var tcp: [Int]
    var udp: [Int]
    
    init() {
        tcp = [Int]()
        udp = [Int]()
    }
}

struct ServerEntry: Codable {
    let server: String
    
    var ports: ServerPortsEntry? = nil
    var country: String? = nil
    var location: String? = nil
    
    var type: ServerEntryType? = nil
    var portsParsed: ServerPortsEntryParsed? = nil

    private func parsePorts(of sPorts: [String]) -> [Int] {
        var result = [Int]()
        sPorts.forEach { p in
            p.split(separator: ",").forEach { portRange in
                if portRange.contains("-") {
                    let range = portRange.split(separator: "-")
                    if range.count == 2,
                       let rangeStart = Int(range[0]),
                       let rangeEnd = Int(range[1]) {
                        for portNumeric in rangeStart...rangeEnd {
                            result.append(portNumeric)
                        }
                    }
                } else {
                    if let portNumeric = Int(portRange) {
                        result.append(portNumeric)
                    }
                }
            }
        }
        return result
    }

    mutating func parsePorts() {
        portsParsed = ServerPortsEntryParsed()
        if let tcpPorts = ports!.tcp {
            portsParsed!.tcp = parsePorts(of: tcpPorts)
        }
        if let udpPorts = ports!.udp {
            portsParsed!.udp = parsePorts(of: udpPorts)
        }
    }
}

extension ServerEntry {
    var countryEmoji: String? {
        switch country {
        case "fr":
            return "🇫🇷"
        case "nl":
            return "🇳🇱"
        case "ee":
            return "🇪🇪"
        case "ua":
            return "🇺🇦"
        case "kz":
            return "🇰🇿"
        case "ru":
            return "🇷🇺"
        case "id":
            return "🇮🇩"
        case "us":
            return "🇺🇸"
        case "de":
            return "🇩🇪"
        case "ch":
            return "🇨🇭"
        case "br":
            return "🇧🇷"
        default:
            return nil
        }
    }
}

//
//  IperfPresetsController.swift
//  iperf-swiftui
//
//  Created by Igor Kim on 09.11.20.
//

import Foundation

enum SaFamily {
    case ipv4
    case ipv6
}

struct NetIfaceAddrResult {
    let name: String
    let addr: String
    let saFamily: SaFamily
}

class IperfPresetsController: ObservableObject {
    @Published var serverEntries = [ServerEntry]()
    @Published var selectedPresetIndex: Int = -1
    
    func loadServersFromJson() {
        let decoder = JSONDecoder()
        if let path = Bundle.main.url(forResource: "servers", withExtension: "json"),
           let data = try? Data(contentsOf: path),
           let obj = try? decoder.decode([ServerEntry].self, from: data) {
            serverEntries = obj
            for i in 0..<serverEntries.count {
                serverEntries[i].type = ServerEntryType.publicServer
                serverEntries[i].parsePorts()
            }
        }
    }
    
    func getNameToAddressDict() -> [String:[NetIfaceAddrResult]] {
        var ifaddr: UnsafeMutablePointer<ifaddrs>? = nil
        var result: [String : [NetIfaceAddrResult]] = [:]
        
        if getifaddrs(&ifaddr) == 0 {
            var ptr = ifaddr
            while ptr != nil {
                defer { ptr = ptr?.pointee.ifa_next }

                guard let interface = ptr?.pointee else { return result }
                
                let addrFamily = interface.ifa_addr.pointee.sa_family
                if addrFamily == UInt8(AF_INET) || addrFamily == UInt8(AF_INET6) {
                    let name = String(cString: (interface.ifa_name))
                    var hostname = [CChar](repeating: 0, count: Int(NI_MAXHOST))
                    getnameinfo(interface.ifa_addr, socklen_t((interface.ifa_addr.pointee.sa_len)), &hostname, socklen_t(hostname.count), nil, socklen_t(0), NI_NUMERICHOST)

                    if result[name] == nil {
                        result[name] = []
                    }
                    result[name]!.append(
                        NetIfaceAddrResult(
                            name: name,
                            addr: String(cString: hostname),
                            saFamily: addrFamily == UInt8(AF_INET) ? .ipv4 : .ipv6
                        )
                    )
                }
            }
            freeifaddrs(ifaddr)
        }
        return result
    }
    
    init() {
        loadServersFromJson()
        
        let addrs = getNameToAddressDict()
        for k in addrs {
            k.value.forEach { iface in
                if iface.saFamily == .ipv4 {
                    self.serverEntries.append(
                        ServerEntry(server: iface.addr, type: ServerEntryType.listenOn)
                    )
                }
            }
        }
    }
}

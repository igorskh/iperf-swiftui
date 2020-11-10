//
//  SelectServerRow.swift
//  iperf-swiftui
//
//  Created by Igor Kim on 09.11.20.
//

import Foundation
import SwiftUI

struct SelectServerRow: View {
    var server: ServerEntry
    var onClick: () -> Void = {}
    
    var body: some View {
        HStack {
            Text(server.countryEmoji ?? "")
            Text(server.server)
            Spacer()
            if server.ports != nil {
                if server.ports!.tcp != nil {
                    Text("TCP")
                        .font(.footnote)
                }
                if server.ports!.udp != nil {
                    Text("UDP")
                        .font(.footnote)
                }
            }
        }.onTapGesture {
            onClick()
        }
    }
}


struct SelectServerRow_Previews: PreviewProvider {
    static var previews: some View {
        SelectServerRow(server: ServerEntry(server: "127.0.0.1", ports: ServerPortsEntry(tcp: nil, udp: nil), country: "de", location: nil, type: .localServer, portsParsed: nil))
    }
}

//
//  ServersList.swift
//  iperf-swiftui
//
//  Created by Igor Kim on 09.11.20.
//

import SwiftUI

struct ServersList: View {
    @Binding var formInput: IperfConfigurationInput
    @Binding var options: [ServerEntry]
    @Binding var selectedTypeIndex: Int
    @Binding var selectedPresetIndex: Int
    @Binding var isPresented: Bool
    
    var body: some View {
        let filteredOptionsIds = options.enumerated().filter {
            $0.element.type == serverTypeOptions[selectedTypeIndex]
        }.map { $0.offset }
        
        return List {
            ForEach(filteredOptionsIds, id: \.self) { i in
                SelectServerRow(server: options[i]) {
                    if let ports = formInput.prot == .udp ? options[i].portsParsed?.udp : options[i].portsParsed?.tcp,
                       let firstPort = ports.first {
                        formInput.port = String(firstPort)
                    } else {
                        formInput.port = defaultPort
                    }
                    
                    selectedPresetIndex = i
                    formInput.address = options[i].server
                    isPresented = false
                }
            }
        }
    }
}

//struct ServersList_Previews: PreviewProvider {
//    static var previews: some View {
//        ServersList()
//    }
//}

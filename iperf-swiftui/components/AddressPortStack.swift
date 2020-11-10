//
//  AddressPortStack.swift
//  iperf-swiftui
//
//  Created by Igor Kim on 09.11.20.
//

import SwiftUI

struct AddressPortStack: View {
    @Binding var formInput: IperfConfigurationInput
    @Binding var serverEntries: [ServerEntry]
    @Binding var selectedPresetIndex: Int
    
    var body: some View {
        HStack {
            TextField("Address", text: $formInput.address)
                .textFieldStyle(RoundedBorderTextFieldStyle())
            
            if serverEntries.count > 0 {
                SelectServerView(options: $serverEntries, formInput: $formInput, selectedPresetIndex: $selectedPresetIndex)
            }
            
            TextField("Port", text: $formInput.port)
                .textFieldStyle(RoundedBorderTextFieldStyle())
            
            if selectedPresetIndex > -1 && selectedPresetIndex < serverEntries.count {
                SelectPortView(server: $serverEntries[selectedPresetIndex], formInput: $formInput)
            }
        }
    }
}

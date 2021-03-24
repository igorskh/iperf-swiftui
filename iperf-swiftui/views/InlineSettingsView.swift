//
//  InlineSettingsView.swift
//  iperf-swiftui
//
//  Created by Igor Kim on 10.11.20.
//

import SwiftUI

struct InlineSettingsView<Content: View>: View {
    @Binding var formInput: IperfConfigurationInput
    @Binding var serverEntries: [ServerEntry]
    @Binding var selectedPresetIndex: Int
    
    let startButtonContent: Content
    
    init(formInput: Binding<IperfConfigurationInput>,
         serverEntries: Binding<[ServerEntry]>,
         selectedPresetIndex: Binding<Int>,
         @ViewBuilder startButton: @escaping () -> Content) {
        self._formInput = formInput
        self._serverEntries = serverEntries
        self._selectedPresetIndex = selectedPresetIndex
        self.startButtonContent = startButton()
    }
    
    var body: some View {
        VStack {
            AddressPortStack(
                formInput: $formInput,
                serverEntries: $serverEntries,
                selectedPresetIndex: $selectedPresetIndex
            )
            .padding(.bottom, 5)
            
            HStack {
                OptionsPicker(
                    options: formInput.roleOptions,
                    selected: $formInput.roleIndex
                )
                
                if formInput.role == .client {
                    OptionsPicker(
                        options: formInput.directionOptions,
                        selected: $formInput.directionIndex
                    )
                }
                MoreSettingsView(formInput: $formInput)
                Spacer()
                
                startButtonContent
            }
        }
    }
}
//
//struct InlineSettingsView_Previews: PreviewProvider {
//    static var previews: some View {
//        InlineSettingsView()
//    }
//}

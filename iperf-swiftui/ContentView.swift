//
//  ContentView.swift
//  iperf3-swift
//
//  Created by Igor Kim on 27.10.20.
//

import SwiftUI
import IperfSwift

let barButtonHeight: CGFloat = 16.0

struct ContentView: View {
    @ObservedObject var iperfRunnerController = IperfRunnerController()
    @ObservedObject var iperfPresetsController = IperfPresetsController()
    
    @State var formInput = IperfConfigurationInput(
        address: "127.0.0.1",
        port: "5201"
    )
    
    var body: some View {
        VStack {
            Text("iPerf3 \(formInput.role.description)")
                .font(.largeTitle)
            
            AddressPortStack(
                formInput: $formInput,
                serverEntries: $iperfPresetsController.serverEntries,
                selectedPresetIndex: $iperfPresetsController.selectedPresetIndex
            )
            
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
                
                StartButton(
                    state: $iperfRunnerController.runnerState,
                    onStartClick: {
                        iperfRunnerController.start(with: formInput)
                    },
                    onStopClick: {
                        iperfRunnerController.stop()
                    })
            }
            .padding(.vertical, 10)
            
            if iperfRunnerController.displayError && iperfRunnerController.debugDescription.count > 0 {
                Text(iperfRunnerController.debugDescription).padding(.vertical, 10)
            }
            
            ResultsView(results: $iperfRunnerController.results)
            Spacer()
        }
        .padding(20)
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}

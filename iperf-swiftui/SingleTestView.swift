//
//  SingleTestView.swift
//  iperf-swiftui
//
//  Created by Igor Kim on 10.11.20.
//

import SwiftUI

struct SingleTestView: View {
    @ObservedObject var runnerController = IperfRunnerController()
    @ObservedObject var presetsController = IperfPresetsController()
    
    @State var formInput = IperfConfigurationInput(
        address: "127.0.0.1",
        port: "5201"
    )
    
    var body: some View {
        VStack {
            Text("iPerf3 \(formInput.role.description)")
                .font(.largeTitle)
            
            InlineSettingsView(
                formInput: $formInput,
                serverEntries: $presetsController.serverEntries,
                selectedPresetIndex: $presetsController.selectedPresetIndex) {
                
                
                StartButton(
                    state: $runnerController.runnerState,
                    onStartClick: {
                        runnerController.start(with: formInput)
                    },
                    onStopClick: {
                        runnerController.stop()
                    })
            }
            .padding(.vertical, 10)
            
            if runnerController.displayError && runnerController.debugDescription.count > 0 {
                Text(runnerController.debugDescription).padding(.vertical, 10)
            }
            ResultsView(results: $runnerController.results)
            
            Spacer()
        }.padding()
    }
}

struct SingleTestView_Previews: PreviewProvider {
    static var previews: some View {
        SingleTestView()
    }
}

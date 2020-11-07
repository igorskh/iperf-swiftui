//
//  ContentView.swift
//  iperf3-swift
//
//  Created by Igor Kim on 27.10.20.
//

import SwiftUI

let barButtonHeight: CGFloat = 16.0

struct ContentView: View {
    private var iperfRunner: IperfRunner = IperfRunner()
    @State var runnerState: IperfRunnerState = .ready

    @State var debugDescription: String = ""
    @State var displayError: Bool = false
    @State var results: [IperfIntervalResult] = []
    @State var formInput = IperfConfigurationInput(
        address: "127.0.0.1",
        port: "5201"
    )
    
    func onResultReceived(result: IperfIntervalResult) {
        if result.runnerState != .unknown && result.runnerState != runnerState {
            runnerState = result.runnerState
        }
        if result.streams.count > 0 {
            results.append(result)
        }
        debugDescription = result.debugDescription
        displayError = result.hasError
    }
    
    var body: some View {
        VStack {
            Text("iPerf3 \(formInput.role.description)")
                .font(.largeTitle)
            
            HStack {
                TextField("Address", text: $formInput.address)
                    .textFieldStyle(RoundedBorderTextFieldStyle())
                TextField("Port", text: $formInput.port)
                    .textFieldStyle(RoundedBorderTextFieldStyle())
            }.animation(Animation.spring().delay(1.0))
            
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
                    state: $runnerState,
                    onStartClick: {
                        results = []
                        debugDescription = ""
                        iperfRunner.start(with: IperfConfiguration(formInput), onResultReceived)
                    },
                    onStopClick: {
                        iperfRunner.stop()
                    })
            }
            .padding(.vertical, 10)
            
            if displayError {
                Text(debugDescription).padding(.vertical, 10)
            }
            
            ResultsView(results: $results)
            
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

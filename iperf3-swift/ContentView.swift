//
//  ContentView.swift
//  iperf3-swift
//
//  Created by Igor Kim on 27.10.20.
//

import SwiftUI

let barButtonHeight: CGFloat = 16.0

struct ContentView: View {
    private let roleOptions: [IperfRole] = [.client, .server]
    private let directionOptions: [IperfDirection] = [.download, .upload]

    @State var debugDescription: String = ""
    @State var displayError: Bool = false
    
    @State var roleIndex: Int = 0
    @State var directionIndex: Int = 0
    
    @State var results: [IperfIntervalResult] = []
    
    @State var formInput = IperfConfigurationInput(
        address: "127.0.0.1",
        port: "5201"
    )
    
    @ObservedObject private var iperfRunner: IperfRunner = IperfRunner()
    
    func onResultReceived(result: IperfIntervalResult) {
        if result.streams.count > 0 {
            results.append(result)
        }
        debugDescription = result.debugDescription
        displayError = result.hasError
    }
    
    var body: some View {
        VStack {
            Text("iPerf3 \(roleOptions[roleIndex].description)")
                .font(.largeTitle)
            
            HStack {
                TextField("Address", text: $formInput.address)
                    .textFieldStyle(RoundedBorderTextFieldStyle())
                TextField("Port", text: $formInput.port)
                    .textFieldStyle(RoundedBorderTextFieldStyle())
            }.animation(Animation.spring().delay(1.0))
            
            HStack {
                OptionsPicker(
                    options: roleOptions,
                    selected: $roleIndex,
                    onChange: { index in formInput.role = roleOptions[index] }
                )
                
                if roleOptions[roleIndex] == .client {
                    OptionsPicker(
                        options: directionOptions,
                        selected: $directionIndex,
                        onChange: { index in formInput.direction = directionOptions[directionIndex] }
                    )
                }
                MoreSettingsView(formInput: $formInput)
                Spacer()
                
                StartButton(
                    state: $iperfRunner.state,
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

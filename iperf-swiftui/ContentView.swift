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
    @ObservedObject var testsController = IperfRunnerTestsController()
    @ObservedObject var iperfPresetsController = IperfPresetsController()
    
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
                serverEntries: $iperfPresetsController.serverEntries,
                selectedPresetIndex: $iperfPresetsController.selectedPresetIndex) {
                
                Button(action: { testsController.addTest(with: formInput) }) {
                    Image(systemName: "plus")
                }
                .font(.title)
            }
            .padding(.vertical, 10)
            
            ScrollView {
                ForEach(testsController.tests.reversed()) { t in
                    if !t.isDeleted {
                        IperfTestView(iperfRunnerController: t)
                            .frame(maxWidth: .infinity, maxHeight: .infinity)
                            .animation(.easeIn)
                            .transition(.slide)
                    }
                }
            }
        }
        .padding(10)
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}

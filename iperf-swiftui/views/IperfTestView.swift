//
//  IperfTestView.swift
//  iperf-swiftui
//
//  Created by Igor Kim on 10.11.20.
//

import SwiftUI

import IperfSwift

struct IperfTestView: View {
    @ObservedObject var iperfRunnerController: IperfRunnerController
    
    var body: some View {
        VStack {
            ZStack {
                HStack {
                    Text("\(iperfRunnerController.formInput.prot.description)://\(iperfRunnerController.formInput.address):\(iperfRunnerController.formInput.port)")
                        .font(.subheadline)
                }
                HStack {
                    Spacer()
                    Button(action: {
                        iperfRunnerController.stop()
                        iperfRunnerController.isDeleted = true
                    }) {
                        Image(systemName: "xmark")
                    }
                    
                }
            }
            
            if iperfRunnerController.displayError && iperfRunnerController.debugDescription.count > 0 {
                Text(iperfRunnerController.debugDescription)
            }
            IperfTestStatusText(runnerState: $iperfRunnerController.runnerState, role: iperfRunnerController.formInput.role, results: $iperfRunnerController.results)
                .padding(.vertical, 5)
            
            if let lastResult = iperfRunnerController.results.last {
                HStack {
                    Image(systemName: iperfRunnerController.formInput.direction.uiImage!)
                        .frame(maxHeight: .infinity, alignment: .center)
                    Text(lastResult.throughput.pretty(format: "%.0f"))
                        .font(.subheadline)
                }
                .padding(.bottom)
            }
            if iperfRunnerController.results.count > 0 {
                ResultsView(results: $iperfRunnerController.results)
            }
        }
        .frame(maxWidth: .infinity)
        .padding(10)
        .background(
            Color(UIColor.secondarySystemGroupedBackground)
                .shadow(color: .primary, radius: 2.0, x: 0.0, y: 0.0)
                .blur(radius: 3.0)
        )
        .padding(5)
    }
}


struct IperfTestStatusText: View {
    @Binding var runnerState: IperfRunnerState
    var role: IperfRole
    @Binding var results: [IperfIntervalResult]
    
    var body: some View {
        ZStack {
            if runnerState == .running
                && results.count == 0 {
                if role == .server {
                    Text("Listnening...")
                } else {
                    Text("Preparing...")
                }
            } else if runnerState != .running
                        && runnerState != .ready
                        && runnerState != .finished {
                Text(runnerState.description)
            }
        }
        .foregroundColor(.primary)
    }
}

//struct IperfTestView_Previews: PreviewProvider {
//    static var previews: some View {
//        IperfTestView()
//    }
//}

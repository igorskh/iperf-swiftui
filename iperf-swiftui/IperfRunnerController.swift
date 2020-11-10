//
//  IperfRunnerController.swift
//  iperf-swiftui
//
//  Created by Igor Kim on 09.11.20.
//

import Foundation
import IperfSwift

class IperfRunnerController: ObservableObject {
    private var iperfRunner: IperfRunner = IperfRunner()
    
    @Published var runnerState: IperfRunnerState = .ready
    @Published var debugDescription: String = ""
    @Published var displayError: Bool = false
    @Published var results: [IperfIntervalResult] = []
    
    func onResultReceived(result: IperfIntervalResult) {
        if result.streams.count > 0 {
            results.append(result)
        }
    }
    
    func onErrorReceived(error: IperfError) {
        DispatchQueue.main.async {
            self.displayError = error != .IENONE
            self.debugDescription = error.debugDescription
        }
    }
    
    func onNewState(state: IperfRunnerState) {
        if state != .unknown && state != runnerState {
            runnerState = state
        }
    }
    
    func start(with formInput: IperfConfigurationInput) {
        results = []
        debugDescription = ""
        iperfRunner.start(
            with: IperfConfiguration(formInput),
            onResultReceived,
            onErrorReceived,
            onNewState
        )
    }
    
    func stop() {
        iperfRunner.stop()
    }
}

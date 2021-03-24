//
//  IperfRunnerTestsController.swift
//  iperf-swiftui
//
//  Created by Igor Kim on 10.11.20.
//

import Foundation

import Combine

class IperfRunnerTestsController: ObservableObject {
    @Published var tests = [IperfRunnerController]()
    private var cancellables = Set<AnyCancellable>()
    
    func addTest(with formInput: IperfConfigurationInput) {
        let filteredTests = tests.filter { t in !t.displayError && (!t.isDeleted && t.runnerState != .stopping) }
        tests = filteredTests
        
        let newTest = IperfRunnerController()
        newTest.objectWillChange.sink(receiveValue: {[weak self] _ in
            self?.objectWillChange.send()
        })
        .store(in: &cancellables)
        
        tests.append(newTest)
        newTest.start(with: formInput)
    }
//    func removeTest(test: IperfRunnerTest) {
//
//    }
}

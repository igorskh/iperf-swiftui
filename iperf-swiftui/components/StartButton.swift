//
//  StartButton.swift
//  iperf3-swift
//
//  Created by Igor Kim on 28.10.20.
//

import SwiftUI

import IperfSwift

struct StartButton: View {
    @Binding var state: IperfRunnerState
    
    var onStartClick: () -> Void = {}
    var onStopClick: () -> Void = {}
    
    var body: some View {
        ZStack {
            if state == .ready || state == .finished || state == .error {
                Button(action: { onStartClick() }) {
                    Image(systemName: "play")
                }
            } else if state == .initialising || state == .stopping {
                Image(systemName: "clock")
                    .foregroundColor(.secondary)
            } else {
                Button(action: { onStopClick() }) {
                    Image(systemName: "stop")
                }
            }
        }.font(.title)
    }
}

struct StartButton_Previews: PreviewProvider {
    static var previews: some View {
        StartButton(state: .constant(.initialising))
    }
}

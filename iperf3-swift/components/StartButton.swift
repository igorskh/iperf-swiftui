//
//  StartButton.swift
//  iperf3-swift
//
//  Created by Igor Kim on 28.10.20.
//

import SwiftUI

struct StartButton: View {
    @Binding var state: IperfRunnerState
    
    var onStartClick: () -> Void = {}
    var onStopClick: () -> Void = {}
    
    var body: some View {
        ZStack {
            if state == .ready {
                Button(action: { onStartClick() }) {
                    Image(systemName: "play")
                }
            } else if state == .initialising  {
                Image(systemName: "clock")
            } else {
                Button(action: { onStopClick() }) {
                    Image(systemName: "stop")
                }
            }
        }.font(.title)
    }
}

//
//  ResultsView.swift
//  iperf3-swift
//
//  Created by Igor Kim on 28.10.20.
//

import SwiftUI

import IperfSwift

struct ResultsView: View {
    @Binding var results: [IperfIntervalResult]
    
    var body: some View {
        VStack {
            ForEach(results.reversed()) { res in
                HStack {
                    Text("\(String(format: "%.2f-%.2f", res.startTime - results.first!.startTime, res.endTime - results.first!.startTime))")
                    Spacer()
                    Text("\(res.throughput.pretty(format: "%.0f"))")
                }
            }
        }
        .animation(.linear)
        .padding(.horizontal)
        .padding(.bottom)
    }
}

struct ResultsView_Previews: PreviewProvider {
    static var previews: some View {
        let results: [IperfIntervalResult] = [
            IperfIntervalResult(),
            IperfIntervalResult()
        ]
        return ResultsView(results: .constant(results))
    }
}

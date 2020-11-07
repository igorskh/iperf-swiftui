//
//  ResultsView.swift
//  iperf3-swift
//
//  Created by Igor Kim on 28.10.20.
//

import SwiftUI

struct ResultsView: View {
    @Binding var results: [IperfIntervalResult]
    
    var body: some View {
        List {
            ForEach(results.reversed()) { res in
                HStack {
                    Text("\(String(format: "%.1f", res.duration))")
                    Spacer()
                    Text("\(res.throughput.pretty)")
                }
            }
        }.animation(.linear)
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

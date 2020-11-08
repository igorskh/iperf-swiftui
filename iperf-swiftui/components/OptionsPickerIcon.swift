//
//  OptionsPickerIcon.swift
//  iperf3-swift
//
//  Created by Igor Kim on 07.11.20.
//

import SwiftUI

struct OptionsPickerIcon: View {
    let backgroundColor: Color
    let uiImage: String?
    let text: String
    
    var body: some View {
        ZStack {
            if let uiImage = uiImage {
                Image(systemName: uiImage).padding(0)
            } else {
                Text(text).padding(0)
            }
        }
        .frame(height: barButtonHeight)
        .padding(10)
        .background(backgroundColor)
    }
}

struct OptionsPickerIcon_Previews: PreviewProvider {
    static var previews: some View {
        Group {
            OptionsPickerIcon(backgroundColor: .white, uiImage: nil, text: "Test")
            OptionsPickerIcon(backgroundColor: .white, uiImage: "circle", text: "Test")
        }
    }
}

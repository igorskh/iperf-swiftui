//
//  OptionsPicker.swift
//  iperf3-swift
//
//  Created by Igor Kim on 28.10.20.
//

import SwiftUI

struct OptionsPicker: View {
    let options: [HasDescription]
    @Binding var selected: Int
    var onChange: (_ newIndex: Int) -> Void = {_ in }
    
    var body: some View {
        HStack(spacing: 0) {
            ForEach(0..<options.count) {
                OptionsPickerIcon(
                    backgroundColor: $0 == selected ? Color.secondary : Color(UIColor.secondarySystemGroupedBackground),
                    uiImage: options[$0].uiImage,
                    text: options[$0].description
                )
            }
        }
        .cornerRadius(5)
        .animation(.spring())
        .onTapGesture {
            selected = (selected + 1)%options.count
            onChange(selected)
        }
    }
}

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

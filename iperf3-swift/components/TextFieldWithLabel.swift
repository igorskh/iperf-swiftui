//
//  TextFieldWithLabel.swift
//  iperf-swiftui
//
//  Created by Igor Kim on 26.10.20.
//

import SwiftUI

struct TextFieldWithLabel: View {
    let label: String
    @Binding var text: String
    var keyboardType: UIKeyboardType = .default
    
    var body: some View {
        HStack {
            Text(label)
            Spacer()
            TextField(label, text: $text)
                .multilineTextAlignment(.trailing)
                .keyboardType(keyboardType)
        }
    }
}

struct TextFieldWithLabel_Previews: PreviewProvider {
    static var previews: some View {
        TextFieldWithLabel(label: "Label", text: .constant("value"))
    }
}

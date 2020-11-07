//
//  TextFieldWithOption.swift
//  iperf3-swift
//
//  Created by Igor Kim on 07.11.20.
//

import SwiftUI

struct TextFieldWithOption<T>: View where T: TextFieldOption {
    let label: String
    @Binding var value: StringWithOption<T>
    var keyboardType: UIKeyboardType = .default
    var options: [T]
    
    var body: some View {
        HStack {
            Text(label)
            Spacer()
            TextField(label, text: $value.value)
                .multilineTextAlignment(.trailing)
                .keyboardType(keyboardType)
            OptionsPicker(
                options: options,
                selected: $value.optionIndex,
                onChange: { index in
                    value.option = options[value.optionIndex]
                }
            )
        }
    }
}

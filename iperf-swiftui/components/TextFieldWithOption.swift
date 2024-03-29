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
        VStack {
            TextFieldWithLabel(
                label: label,
                text: $value.value,
                keyboardType: keyboardType
            )
            HStack {
                Spacer()
                
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
}

struct TextFieldWithOption_Previews: PreviewProvider {
    static var previews: some View {
        let opt = StringWithOption<RateOption>(value: "1", option: rateOptions[0], optionIndex: 0)
        return TextFieldWithOption(label: "test", value: .constant(opt), options: rateOptions)
    }
}

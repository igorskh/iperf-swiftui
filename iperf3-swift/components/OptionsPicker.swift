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
            ForEach(0..<options.count) { index in
                OptionsPickerIcon(
                    backgroundColor: index == selected ? Color.secondary : Color(UIColor.secondarySystemGroupedBackground),
                    uiImage: options[index].uiImage,
                    text: options[index].description
                )
                .onTapGesture {
                    selected = index == selected ? (selected + 1)%options.count : index
                    onChange(selected)
                }
            }
        }
        .cornerRadius(5)
        .animation(.spring())
    }
}

struct OptionsPicker_Previews: PreviewProvider {
    static var previews: some View {
        let formInput = IperfConfigurationInput(address: "")
        OptionsPicker(options: formInput.protocolOptions, selected: .constant(0))
    }
}

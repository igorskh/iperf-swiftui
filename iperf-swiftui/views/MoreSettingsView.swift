//
//  MoreSettingsView.swift
//  iperf3-swift
//
//  Created by Igor Kim on 28.10.20.
//

import SwiftUI

let rateOptions: [RateOption] = [.Kbps, .Mbps, .Gbps]

struct MoreSettingsView: View {
    @State var isPresented: Bool = false
    @Binding var formInput: IperfConfigurationInput
    
    var body: some View {
        Button(action: { isPresented = true }) {
            Image(systemName: "ellipsis")
                .frame(height: barButtonHeight)
                .padding(10)
                .background(Color.secondary)
                .foregroundColor(Color.primary)
                .cornerRadius(5)
        }
        .sheet(isPresented: $isPresented) {
            NavigationView {
                Form {
                    if formInput.role == .client {
                        Section {
                            HStack {
                                Text("Protocol")
                                Spacer()
                                OptionsPicker(
                                    options: formInput.protocolOptions,
                                    selected: $formInput.protocolIndex
                                )
                            }
                        }
                        Section {
                            TextFieldWithLabel(label: "Duration", text: $formInput.duration)
                            if formInput.prot == .tcp {
                                TextFieldWithLabel(label: "Streams", text: $formInput.nofStreams)
                            }
                            if formInput.prot == .udp {
                                TextFieldWithOption(label: "Rate", value: $formInput.rate, options: rateOptions)
                            }
                        }
                    }
                    
                    Section {
                        TextFieldWithLabel(label: "Reporting Interval", text: $formInput.reportInterval)
                        TextFieldWithLabel(label: "Connection Timeout", text: $formInput.timeout)
                    }
                }
                .navigationBarTitle("Additional Parameters", displayMode: .inline)
                .navigationBarItems(trailing: Button("Done") { isPresented = false} )
            }
            .navigationViewStyle(StackNavigationViewStyle())
        }
    }
}

struct MoreSettingsView_Previews: PreviewProvider {
    
    static var previews: some View {
        MoreSettingsView(formInput: .constant(IperfConfigurationInput(address: "123.123.123.123")))
    }
}

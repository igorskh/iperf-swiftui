//
//  MoreSettingsView.swift
//  iperf3-swift
//
//  Created by Igor Kim on 28.10.20.
//

import SwiftUI

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
                            TextFieldWithLabel(label: "Duration", text: $formInput.duration)
                            TextFieldWithLabel(label: "Streams", text: $formInput.nofStreams)
                            TextFieldWithLabel(label: "TOS", text: $formInput.tos)
                        }
                    }
                    Section {
                        TextFieldWithLabel(label: "Reporting Interval", text: $formInput.reportInterval)
                    }
                }
                .navigationBarTitle("Additional Parameters", displayMode: .inline)
                .navigationBarItems(trailing: Button("Done") { isPresented = false} )
            }
            .navigationViewStyle(StackNavigationViewStyle())
        }
    }
}

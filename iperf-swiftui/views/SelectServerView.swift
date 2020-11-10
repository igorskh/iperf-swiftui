//
//  SelectServerView.swift
//  iperf-swiftui
//
//  Created by Igor Kim on 09.11.20.
//

import SwiftUI

let defaultPort = "5201"
let serverTypeOptions: [ServerEntryType] = [.listenOn, .publicServer]

struct SelectServerView: View {
    @Binding var options: [ServerEntry]
    @Binding var formInput: IperfConfigurationInput
    @Binding var selectedPresetIndex: Int
    
    @State var isPresented = false
    @State var selectedTypeIndex: Int = 0
    
    var body: some View {
        Button(action: { isPresented.toggle() }) {
            Image(systemName: "chevron.down.square.fill")
                .font(.title)
                .foregroundColor(Color.primary)
        }
        .sheet(isPresented: $isPresented) {
            NavigationView {
                VStack {
                    HStack {
                        OptionsPicker(options: serverTypeOptions, selected: $selectedTypeIndex)
                        Spacer()
                    }.padding(20)
                    if serverTypeOptions[selectedTypeIndex] == .publicServer {
                        Text("Sources: iperf.fr/iperf-servers.php, iperf.cc")
                            .font(.footnote)
                            .frame(maxWidth: .infinity, alignment: .leading)
                            .padding(.horizontal, 20)
                    }
                    ServersList(
                        formInput: $formInput,
                        options: $options,
                        selectedTypeIndex: $selectedTypeIndex,
                        selectedPresetIndex: $selectedPresetIndex,
                        isPresented: $isPresented
                    )
                }
                .navigationBarTitle("Public servers", displayMode: .inline)
                .navigationBarItems(trailing: Button("Done") { isPresented = false} )
            }
            .navigationViewStyle(StackNavigationViewStyle())
        }
    
    }
}

struct SelectServerView_Previews: PreviewProvider {
    static var previews: some View {
        SelectServerView(
            options: .constant([ServerEntry]()),
            formInput: .constant(IperfConfigurationInput(address: "127.0.0.1")),
            selectedPresetIndex: .constant(-1)
        )
    }
}

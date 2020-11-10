//
//  SelectPortView.swift
//  iperf-swiftui
//
//  Created by Igor Kim on 09.11.20.
//

import SwiftUI

struct SelectPortView: View {
    @Binding var server: ServerEntry
    @Binding var formInput: IperfConfigurationInput
    
    @State var isPresented = false
    
    var body: some View {
        let ports = formInput.prot == .udp ? server.portsParsed?.udp : server.portsParsed?.tcp
        
        return Button(action: { isPresented.toggle() }) {
            Image(systemName: "chevron.down.square.fill")
                .font(.title)
                .foregroundColor(Color.primary)
        }
        .foregroundColor(ports == nil || ports!.count == 0 ? .gray : .primary)
        .sheet(isPresented: $isPresented) {
            NavigationView {
                VStack {
                    if ports == nil || ports!.count == 0 {
                        Text("No ports available for \(formInput.prot.description)")
                    } else {
                        List {
                            ForEach(0..<ports!.count) { i in
                                Text(String(ports![i]))
                                    .onTapGesture {
                                        formInput.port = String(ports![i])
                                        isPresented = false
                                    }
                            }
                        }
                    }
                }
                .navigationBarTitle("Select port", displayMode: .inline)
                .navigationBarItems(trailing: Button("Done") { isPresented = false} )
            }
            .navigationViewStyle(StackNavigationViewStyle())
        }
    }
}

//struct SelectPortView_Previews: PreviewProvider {
//    static var previews: some View {
//        SelectPortView()
//    }
//}

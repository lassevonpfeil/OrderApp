//
//  InfoButton.swift
//  BestellwesenApp
//
//  Created by Lasse von Pfeil on 01.06.23.
//

import SwiftUI

struct InfoButton: View {
    
    @State var showAlert = false
    
    var body: some View {
        VStack {
            Button {
                showAlert = true
            } label: {
                Image(systemName: "info.circle")
            }
            .alert(isPresented: $showAlert) {
                Alert(
                    title: Text("Info"),
                    message: Text("App version 1.0\nProgrammed by Lasse von Pfeil\n© 2023 Lasse von Pfeil")
                )
            }
        }
    }
}

struct InfoButton_Previews: PreviewProvider {
    static var previews: some View {
        InfoButton()
    }
}

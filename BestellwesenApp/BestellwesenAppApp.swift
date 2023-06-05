//
//  BestellwesenAppApp.swift
//  BestellwesenApp
//
//  Created by Lasse von Pfeil on 28.05.23.
//

import SwiftUI

@main
struct BestellwesenAppApp: App {
    
    @StateObject private var dataController = DataController()
    
    var body: some Scene {
        WindowGroup {
            ContentView()
                .environment(\.managedObjectContext, dataController.container.viewContext)
        }
    }
}

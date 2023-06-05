//
//  DetailView.swift
//  BestellwesenApp
//
//  Created by Lasse von Pfeil on 28.05.23.
//

import SwiftUI
import CoreData


struct DetailView: View {
    
    @Environment(\.managedObjectContext) var moc
    @FetchRequest(sortDescriptors: [SortDescriptor(\.name)]) var items: FetchedResults<Inventar>
    
    @State var name: String
    @State var isAvailable: Bool
    @State var location: String
    @State var website: String
    @State var quantity: Float
    @State var quantityNeed: Int
    @State var quantityMin: Int
    @State var indexNum: Int
    
    func save() {
        items[indexNum].quantity = Float(Int(quantity))
        if items[indexNum].quantity < Float(items[indexNum].quantityMin) {
            items[indexNum].order = true
        } else {
            items[indexNum].order = false
        }
        try? moc.save()
    }
    
    
    var body: some View {
        VStack {
            HStack {
                Text("Name:")
                    .font(.title2)
                    .foregroundColor(.secondary)
                    .padding(.leading)
                Spacer()
                Text(name)
                    .font(.title)
                    .padding(.trailing)
            }
            Divider()
            HStack {
                Text("Verfügbar:")
                    .font(.title2)
                    .foregroundColor(.secondary)
                    .padding(.leading)
                Spacer()
                Text(quantity > 0 ? "Verfügbar" : "Nicht verfügbar")
                    .font(.title)
                    .padding(.trailing)
                    .foregroundColor(quantity > 0 ? .green : .red)
                
            }
            Divider()
            HStack {
                Text("Ort:")
                    .font(.title2)
                    .foregroundColor(.secondary)
                    .padding(.leading)
                Spacer()
                Text(location)
                    .font(.title)
                    .padding(.trailing)
                
            }
            Divider()
            HStack {
                Text("Website:")
                    .font(.title2)
                    .foregroundColor(.secondary)
                    .padding(.leading)
                Spacer()
                Text(website)
                    .font(.title)
                    .padding(.trailing)
            }
            Divider()
            VStack {
                HStack {
                    Text("Anzahl:")
                        .font(.title2)
                        .foregroundColor(.secondary)
                        .padding(.leading)
                    Spacer()
                    Slider(value: $quantity, in: 0...100, step: 1)
                        .padding(.leading)
                        .padding(.trailing)
                        .onChange(of: quantity) { _ in
                           save()
                        }
                    Spacer()
                    Text("\(Int(quantity))")
                        .font(.title)
                        .foregroundColor(quantity > 0 ? .green : .red)
                        .padding(.trailing)
                }
                Divider()
                HStack {
                    Text("Anzahl (benötigt):")
                        .font(.title2)
                        .foregroundColor(.secondary)
                        .padding(.leading)
                    Spacer()
                    Text("\(quantityNeed)")
                        .font(.title)
                        .padding(.trailing)
                }
                Divider()
                HStack {
                    Text("Anzahl (Min):")
                        .font(.title2)
                        .foregroundColor(.secondary)
                        .padding(.leading)
                    Spacer()
                    Text("\(quantityMin)")
                        .font(.title)
                        .padding(.trailing)
                }
            }
        }
        .navigationTitle("\(name)")
        Spacer()
    }
}

struct DetailView_Previews: PreviewProvider {
    static var previews: some View {
        DetailView(name: "Test", isAvailable: true, location: "Test", website: "Test", quantity: 0, quantityNeed: 0, quantityMin: 0, indexNum: 0)
    }
}

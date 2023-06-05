//
//  ContentView.swift
//  BestellwesenApp
//
//  Created by Lasse von Pfeil on 28.05.23.
//

import SwiftUI


enum Availability: String, Identifiable, CaseIterable {
    var id: UUID {
        return UUID()
    }
    case not = "false"
    case yes = "true"
}

extension Availability {
    var title: String {
        switch self {
        case .not:
            return "Nicht verfügbar"
        case .yes:
            return "Verfügbar"
        }
    }
}

struct MainView: View {
    
    @Environment(\.managedObjectContext) var moc
    @FetchRequest(sortDescriptors: [SortDescriptor(\.name)]) var items: FetchedResults<Inventar>
    
    @State var presentSheet = false
    @State var selectedAvailability = Availability.yes
    
    @State var addName = ""
    @State var addLocation = ""
    @State var addWebsite = ""
    @State var addQuantity = 0.0
    @State var addQuantityNeed = 0.0
    @State var addQuantityMin = 0.0
    
    
    @State var showInfoAlert = false
    
    func removeItem(at offsets: IndexSet) {
        for index in offsets {
            let item = items[index]
            moc.delete(item)
        }
        try? moc.save()
    }
    
    
    var body: some View {
        NavigationView {
            VStack {
                List {
                    NavigationLink {
                        OrderingView()
                    } label: {
                        Text("Zu Bestellen")
                            .foregroundColor(.blue)
                    }
                    ForEach(items.indices, id: \.self) { item in
                        NavigationLink {
                            //DetailView(name: "\(item.name ?? "Unknown")", isAvailable: item.isAvailable, location: "\(item.location ?? "Unknown")", website: "\(item.website ?? "Unknown")", quantity: Float(Int(item.quantity)), quantityNeed: Int(item.quantityNeed), quantityMin: Int(item.quantityMin))
                            DetailView(name: "\(items[item].name ?? "Unknown")", isAvailable: items[item].isAvailable, location: "\(items[item].location ?? "Unknown")", website: "\(items[item].website ?? "Unknown")", quantity: Float(Int(items[item].quantity)), quantityNeed: Int(items[item].quantityNeed), quantityMin: Int(items[item].quantityMin), indexNum: item)
                        } label: {
                            Text("\(items[item].name ?? "Unknown")")
                        }
                    }
                    .onDelete(perform: removeItem)
                }
                .toolbar {
                    ToolbarItem(placement: .navigationBarTrailing) {
                        Button {
                            presentSheet.toggle()
                        } label: {
                            Image(systemName: "plus")
                        }
                        .sheet(isPresented: $presentSheet) {
                            Text("Hinzufügen")
                                .font(.title)
                                .fontWeight(.bold)
                                //.padding()
                            VStack {
                                TextField("Name", text: $addName)
                                    .textFieldStyle(.roundedBorder)
                                    .padding(.leading)
                                    .padding(.trailing)
                                    .autocorrectionDisabled(true)
                                
                                Divider()
                                
                                Picker("Availability", selection: $selectedAvailability) {
                                    ForEach(Availability.allCases) { availability in
                                        Text(availability.title).tag(availability)
                                    }
                                }
                                .pickerStyle(.segmented)
                                .padding(.leading)
                                .padding(.trailing)
                                
                                Divider()
                                
                                TextField("Ort", text: $addLocation)
                                    .textFieldStyle(.roundedBorder)
                                    .padding(.leading)
                                    .padding(.trailing)
                                    .autocorrectionDisabled(true)
                                
                                Divider()
                                
                                TextField("Website", text: $addWebsite)
                                    .textFieldStyle(.roundedBorder)
                                    .padding(.leading)
                                    .padding(.trailing)
                                    .autocorrectionDisabled(true)
                                    .autocapitalization(.none)
                                
                                Divider()
                            }
                            
                            VStack {
                                Slider(value: $addQuantity, in: 0...100, step: 1)
                                    .padding(.leading)
                                    .padding(.trailing)
                                
                                Text("Anzahl: \(Int(addQuantity))")
                                
                                Divider()
                                
                                Slider(value: $addQuantityNeed, in: 0...100, step: 1)
                                    .padding(.leading)
                                    .padding(.trailing)
                                
                                Text("Anzahl (benötigt): \(Int(addQuantityNeed))")
                                
                                
                                Divider()
                                
                                Slider(value: $addQuantityMin, in: 0...100, step: 1)
                                    .padding(.leading)
                                    .padding(.trailing)
                                
                                Text("Anzahl (Min): \(Int(addQuantityMin))")
                                
                                //Divider()
                            }
                            Button {
                                let inventar = Inventar(context: moc)
                                
                                inventar.id = UUID()
                                inventar.name = addName
                                if selectedAvailability == .yes {
                                    inventar.isAvailable = true
                                } else {
                                    inventar.isAvailable = false
                                }
                                inventar.location = addLocation
                                inventar.quantity = Float(addQuantity)
                                inventar.quantityNeed = Int16(addQuantityNeed)
                                inventar.quantityMin = Int16(addQuantityMin)
                                inventar.website = addWebsite
                                
                                if inventar.quantity < Float(inventar.quantityMin) {
                                    inventar.order = true
                                } else {
                                    inventar.order = false
                                }
                                
                                if inventar.name == "" {
                                    showInfoAlert = true
                                } else {
                                    try? moc.save()
                                    
                                    addName = ""
                                    addLocation = ""
                                    addWebsite = ""
                                    
                                    presentSheet.toggle()
                                }
                            } label: {
                                Text("Hinzufügen")
                            }
                            .alert(isPresented: $showInfoAlert) {
                                Alert(
                                    title: Text("Important message"),
                                    message: Text("Please add a name!")
                                )
                            }
                            .padding()
                        }
                    }
                    ToolbarItem(placement: .navigationBarLeading) {
                        InfoButton()
                    }
                }
            }
            .navigationTitle("Bestellwesen")
        }
    }
}

struct MainView_Previews: PreviewProvider {
    static var previews: some View {
        MainView()
    }
}

//
//  OrderingView.swift
//  BestellwesenApp
//
//  Created by Lasse von Pfeil on 31.05.23.
//

import SwiftUI

struct OrderingView: View {
    
    @Environment(\.managedObjectContext) var moc
    @FetchRequest(sortDescriptors: [SortDescriptor(\.name)]) var items: FetchedResults<Inventar>
    
    
    var body: some View {
        VStack {
            List {
                ForEach(items.indices, id: \.self) { item in
                    Text("\(items[item].name ?? "")")
                        .foregroundColor(items[item].order ? .red : .green)
                }
            }
        }
        .navigationTitle("Zu Bestellen")
    }
}

struct OrderingView_Previews: PreviewProvider {
    static var previews: some View {
        OrderingView()
    }
}

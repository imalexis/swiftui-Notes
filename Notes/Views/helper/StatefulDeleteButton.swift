//
//  StatefulDeleteButton.swift
//  Notes
//
//  Created by alexis on 2/3/21.
//

import SwiftUI

struct StatefulDeleteButton: View {

    @Binding var checkedSet: Set<String>
    @Environment(\.managedObjectContext) private var viewContext
    @FetchRequest(
        sortDescriptors: [NSSortDescriptor(keyPath: \Item.timestamp, ascending: true)],
        animation: .default)
    private var items: FetchedResults<Item>

    @Binding var selectable: Bool

    func deleteInBatches() {
        for val in checkedSet {
            for item in items {
                if item.id!.uuidString == val {
                    viewContext.delete(item)
                    do {
                        try viewContext.save()
                    } catch {
                        print(error.localizedDescription)
                    }
                }
            }
        }
    }

    var body: some View {
        if selectable {
            Button(action: { deleteInBatches() }, label: {
                Text("Delete")
            })
        } else {
            NavigationLink(destination: CreateNotes()) {
                Image(systemName: "square.and.pencil")
                    .imageScale(.large)
                    .foregroundColor(Color(.systemYellow))

            }
        }
    }

//    struct StatefulDeleteButton_Previews: PreviewProvider {
//        static var previews: some View {
//            StatefulDeleteButton()
//        }
//    }
}

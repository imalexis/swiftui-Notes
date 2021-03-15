//
//  ListView.swift
//  Notes
//
//  Created by alexis on 12/3/21.
//

import SwiftUI

struct NotesList: View {
    
    @Environment(\.managedObjectContext) private var viewContext

    @FetchRequest(
        sortDescriptors: [NSSortDescriptor(keyPath: \Item.timestamp, ascending: true)],
        animation: .default)
    private var items: FetchedResults<Item>
    
    @Binding var selectable: Bool
    @Binding var isActive: Bool
    @Binding var checkedSet: Set<String>
    @Binding var showListSheet: Bool
    @ObservedObject var searchBar = SearchBar()
    
    func filterItem(item: Item) -> Bool {
        return searchBar.text.isEmpty ||
            (item.title != nil && item.title!.contains(searchBar.text)) ||
            (item.content != nil &&
                item.content!.contains(searchBar.text))
    }
    
    var body: some View {
        NavigationView {
            List {
                ForEach(items) { item in
                    if filterItem(item: item) {
                        NotesItem(selectable: $selectable, item: item, checkedSet: $checkedSet)
                    }
                }
                .onDelete(perform: { indexSet in
                    for index in indexSet {
                        viewContext.delete(items[index])
                    }
                    do {
                        try viewContext.save()
                    } catch {
                        print(error.localizedDescription)
                    }
                })
            }
            .add(self.searchBar)
            .background(
                NavigationLink(destination: CreateNotes(), isActive: $isActive) {}
            )
            .navigationBarTitle(Text("Notes"))
            .navigationBarItems(
                trailing: NotesListFunctionButton(selectable: $selectable, showListSheet: $showListSheet, checkedSet: $checkedSet))
            .sheet(isPresented: $showListSheet) {
                NotesListSheet(selectable: $selectable)
            }
            .toolbar {
                ToolbarItem(placement: .bottomBar, content: { Spacer() })
                ToolbarItem(placement: .bottomBar, content: { Text("\(items.count) Notes").font(.system(size: 14, weight: .light, design: .rounded)) })
                ToolbarItem(placement: .bottomBar, content: { Spacer() })
                ToolbarItem(placement: .bottomBar, content: {
                    StatefulDeleteButton(checkedSet: $checkedSet, selectable: $selectable, isActive: $isActive)
                })
            }
        }
        // Color("button") <- button -> button color file
        .accentColor(Color("buttonColor"))
    }
}


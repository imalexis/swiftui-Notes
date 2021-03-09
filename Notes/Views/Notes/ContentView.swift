//
//  ContentView.swift
//  Notes
//
//  Created by alexis on 9/2/21.
//

import CoreData
import SwiftUI

struct ContentView: View {
    @ObservedObject var searchBar: SearchBar = SearchBar()
    
    @Environment(\.managedObjectContext) private var viewContext

    @FetchRequest(
        sortDescriptors: [NSSortDescriptor(keyPath: \Item.timestamp, ascending: true)],
        animation: .default)
    private var items: FetchedResults<Item>

    @State var showListSheet = false
    @State var checkedSet = Set<String>()
    @State var selectable = false
    
    func filterItem(item:Item) -> Bool {
        return searchBar.text.isEmpty ||
            (item.title != nil && item.title!.contains(searchBar.text)) ||
            (item.content != nil &&
                item.content!.contains(searchBar.text))
    }
    
    var body: some View {
        NavigationView {
            
            List{
//                HStack {
//                    Image(systemName: "magnifyingglass").foregroundColor(Color(.systemGray))
//                    TextField("Search", text: $searchText)
//                    Button(action: {}, label: {Image(systemName: "mic.fill").foregroundColor(Color(.systemGray))})
//
//                }
//                .padding(7)
//                .background(Color(.systemGray6))
//                .cornerRadius(8)
                
                
                
                ForEach(items) { item in
                    // FIXIME(click search would panic)
                    if filterItem(item: item){
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

            .navigationTitle(Text("Notes"))
            .navigationBarItems(
                
                trailing: NotesListFunctionButton(selectable: $selectable, showListSheet: $showListSheet, checkedSet: $checkedSet))
            .sheet(isPresented: $showListSheet) {
                NotesListSheet(selectable: $selectable)
            }
            .toolbar {
                ToolbarItem(placement: .bottomBar, content: {Spacer()})
                ToolbarItem(placement: .bottomBar, content: {Text("\(items.count) Notes").font(.system(size: 14, weight: .light, design: .rounded))})
                ToolbarItem(placement: .bottomBar, content: {Spacer()})
                ToolbarItem(placement: .bottomBar, content: {
                    StatefulDeleteButton(checkedSet: $checkedSet, selectable: $selectable)
                })
            }
            }
        }
    }



struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView().environment(\.managedObjectContext, PersistenceController.preview.container.viewContext)
    }
}


//
//  NotesDetail.swift
//  Notes
//
//  Created by alexis on 21/2/21.
//

import SwiftUI

struct CreateNotes: View {
    @Environment(\.managedObjectContext) private var viewContext
    @Environment(\.presentationMode) var presentationMode
    @State var title = ""
    @State var content = ""
    
    
    var body: some View {
            NavigationView {
                Form {
                    Section(header: Text("Your title")) {
                        TextEditor(text: $title)
                    }
                    Section(header: Text("Your content")) {
                        TextEditor(text: $content)
                    }
                }
            }
            .navigationBarItems(trailing: Button(action: {
                let newItem = Item(context: viewContext)
                newItem.title = self.title
                newItem.content = self.content
                newItem.id = UUID()
                newItem.timestamp = Date()
                do {
                    try viewContext.save()
                    print("Item saved.")
                    presentationMode.wrappedValue.dismiss()
                } catch {
                    print(error.localizedDescription)
                }
            }, label: {
                Text("Done")
            }))
        
    }
}

struct CreateNotes_Previews: PreviewProvider {
    static var previews: some View {
        CreateNotes()
    }
}

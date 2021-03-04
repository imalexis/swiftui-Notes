//
//  NotesListFunctionButton.swift
//  Notes
//
//  Created by alexis on 24/2/21.
//

import SwiftUI

struct NotesListFunctionButton: View {
    @Environment(\.managedObjectContext) private var viewContext
    
    
    @Binding var selectable: Bool
    @Binding var showListSheet: Bool
    @Binding var checkedSet: Set<String>
    
    var body: some View {
        if selectable {
            Button(action: {
                selectable = false
            } , label: {
                Text("Done")
            })
        } else {
            Button(action: {showListSheet = true} , label: {
                Image(systemName: "ellipsis.circle")
                    .imageScale(.large)
            })
        }
    }
    

}

//struct NotesListFunctionButton_Previews: PreviewProvider {
//    static var previews: some View {
//        NotesListFunctionButton(selectable: $selectable, showListSheet: $showListSheet)
//    }
//}

//
//  ListSheet.swift
//  Notes
//
//  Created by alexis on 23/2/21.
//

import SwiftUI

struct NotesListSheet: View {
    @Environment (\.presentationMode) var presentationMode
    @Binding var selectable: Bool
    
    var body: some View {
        Form {
            Button(action:  {
                presentationMode.wrappedValue.dismiss()
                selectable = true
            }, label: {
                HStack {
                    Text("Selected Notes").foregroundColor(.black)
                    Spacer()
                    Image(systemName: "rectangle.badge.checkmark")
                        .imageScale(.large)
                        .foregroundColor(.black)
                }
            })
        }
    }
}

//struct ListSheet_Previews: PreviewProvider {
//    @State var selectable = false
//    static var previews: some View {
//        ListSheet(selectable: selectable)
//    }
//}

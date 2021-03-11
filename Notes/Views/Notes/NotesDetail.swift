//
//  NotesDetail.swift
//  Notes
//
//  Created by alexis on 22/2/21.
//

import SwiftUI
import KeyboardKit


private let itemFormatter: DateFormatter = {
    let formatter = DateFormatter()
    formatter.dateStyle = .medium
    formatter.timeStyle = .medium
    return formatter
}()

struct NotesDetail: View {
    @Environment(\.managedObjectContext) private var viewContext

    var item: Item

    @State var inputText: String

    var body: some View {
        
        ScrollView {
        
            Text("\(item.timestamp!, formatter: itemFormatter)")
            TextEditor(text: $inputText)
                .keyboardType(.default)
                .autocapitalization(.none)
                .lineSpacing(10)
                .onChange(of: inputText,
                  perform: { value in
                   
                    var inputTextArr = value.split(maxSplits: 1, whereSeparator: { $0 == "\n" }).map(String.init)
                    print("inputText", inputText, "value", value, "arr", inputTextArr.count)
                    if inputText.count == 2 {
                        do {
                               item.title = inputTextArr[0]
                               item.content = inputTextArr[1]
                               try viewContext.save()
                               print("save done")
                       } catch {
                               print("error")
                       }
                    }
                    
                    if inputText.count == 1 {
                        do {
                            item.title = inputTextArr[0]
                            item.content = ""
                            try viewContext.save()
                            print("save done")
                        } catch {
                            print("error")
                        }
                    }
                    
                    if inputText.count == 0 {
                        do {
                            item.title = ""
                            item.content = ""
                            try viewContext.save()
                            print("save done")
                        } catch {
                            print("error")
                        }
                    }
                }).frame(height: 400)
        
        }
        
        


    }
    }

struct NotesDetail_Previews: PreviewProvider {
    static var previews: some View {
        NotesDetail(item: Item(), inputText: "ww")
    }
}

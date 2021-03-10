//
//  NotesDetail.swift
//  Notes
//
//  Created by alexis on 22/2/21.
//

import SwiftUI



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
                .onChange(of: inputText, perform: { value in
                    // how to split string by \n in swift
                    // let firstLineBreak = value.firstIndex(of: "\n")
                    let inputTextArr = inputText.split(maxSplits: 1, whereSeparator: { $0 == "\n" }).map(String.init)
                    
                    if inputText.count == 2 {
                        do {
                            item.title = inputTextArr[0]
                            item.content = inputTextArr[1]
                            try viewContext.save()
                        } catch {
                            print("error")
                        }
                    } else {
                        do {
                            item.title = inputTextArr[0]
                            item.content = ""
                            try viewContext.save()
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

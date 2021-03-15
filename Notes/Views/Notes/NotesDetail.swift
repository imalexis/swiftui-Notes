//
//  NotesDetail.swift
//  Notes
//
//  Created by alexis on 22/2/21.
//

import KeyboardKit
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
    @State var isShowImagePickerSheet = false
    @State var imageInCoordinator: Image? = nil

    var body: some View {
        VStack {
            Text("\(item.timestamp!, formatter: itemFormatter)")
                .font(.system(size: 16, weight: .light, design: .rounded))
                .foregroundColor(Color(.systemGray))
            TextEditor(text: $inputText)
                .keyboardType(.default)
                .autocapitalization(.none)
                .lineSpacing(10)
                .onChange(of: inputText,
                          perform: { value in

                              let inputTextArr = value.split(maxSplits: 1, whereSeparator: { $0 == "\n" }).map(String.init)

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
            Spacer()
            HStack {
                Button(action: {}, label: {
                    Image(systemName: "checkmark.circle")
                        .imageScale(.large)
                })
                Spacer()
                Button(action: {isShowImagePickerSheet = true}, label: {
                    Image(systemName: "camera")
                        .imageScale(.large)
                })
                .sheet(isPresented: $isShowImagePickerSheet) {
                    ImagePickerSheet(
                        imageInCoordinator: $imageInCoordinator
                    )
                }
                Spacer()
                Button(action: {}, label: {
                    Image(systemName: "pencil.tip.crop.circle")
                        .imageScale(.large)
                })
                Spacer()
                Button(action: {}, label: {
                    Image(systemName: "square.and.pencil")
                        .imageScale(.large)
                })
            }
            .padding(20)
        }
    }
}



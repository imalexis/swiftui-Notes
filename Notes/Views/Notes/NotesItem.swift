//
//  ItemDetail.swift
//  Notes
//
//  Created by alexis on 24/2/21.
//

import SwiftUI

private let itemFormatter: DateFormatter = {
    let formatter = DateFormatter()
    formatter.dateStyle = .short
    return formatter
}()

struct NotesItem: View {
    @Binding var selectable: Bool
    var item: Item
    @State var isChecked = false
    @Binding var checkedSet: Set<String>
    
    var body: some View {
        HStack {
//        if selectable {
//            Button(action: {
//
//                    }, label: {
//                        Text("Hello World")
//                            .padding(.all, 5)
//                            .background(self.selectable ? Color.blue : Color.white)
//                            .foregroundColor(self.selectable ? Color.white : Color.blue)
//                    })
//        }
            if !selectable {
                NavigationLink(destination: NotesDetail(item: item, inputText: "\(item.title ?? "") \n \(item.content ?? "")")) {
                    HStack(alignment: .center) {
                        VStack(alignment: .leading) {
                            Text("\(item.title ?? "")")
                                .font(.system(size: 20, weight: .medium, design: .rounded))
                            HStack {
                                if item.timestamp != nil {
                                Text("\(item.timestamp!, formatter: itemFormatter)")
                                    .font(.system(size: 16, weight: .thin, design: .rounded))
                                }
                                Text("\(item.content ?? "")")
                                    .font(.system(size: 16, weight: .thin, design: .rounded))
                            }
                            
                        }
                    }.frame(height: 50)
                }
            } else {
                HStack(alignment: .center) {
                    VStack(alignment: .leading) {
                        HStack {
                            if !isChecked {
                                Button(action: {
                                    isChecked = true
                                    checkedSet.insert(item.id!.uuidString)
                                }, label: {
                                    Image(systemName: "circle")
                                        .imageScale(.large)
                                        .foregroundColor(.gray)
                                })
                            } else {
                                Button(action: {
                                    isChecked = false
                                    checkedSet.remove(item.id!.uuidString)
                                }, label: {
                                    Image(systemName: "checkmark.circle")
                                        .imageScale(.large)
                                        .foregroundColor(.yellow)
                                })
                            }
                            
                            Text("\(item.title!)")
                                .font(.system(size: 20, weight: .black, design: .rounded))
                            Text("\(item.content!)")
                                .font(.system(size: 16, weight: .light, design: .rounded))
                                .foregroundColor(Color(.systemGray6))
                        }
                    }
                }
            }
        }
    }
}

//
// struct ItemDetail_Previews: PreviewProvider {
//    static var previews: some View {
//        var item = Item()
//        item.content = "123"
//        item.title = "123"
//
//        ItemDetail(item: item)
//    }
// }

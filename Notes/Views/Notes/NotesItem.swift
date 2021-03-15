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
            if !selectable {
                NavigationLink(destination: NotesDetail(item: item, inputText: "\(item.title ?? "") \n \(item.content ?? "")")) {
                    HStack(alignment: .center) {
                        VStack(alignment: .leading) {
                            Text("\(item.title ?? "")")
                                .font(.system(size: 20, weight: .medium, design: .rounded))
                                
                            HStack {
                                if item.timestamp != nil {
                                    Text("\(item.timestamp!, formatter: itemFormatter)")
                                        .font(.system(size: 16, weight: .light, design: .rounded))
                                        .foregroundColor(Color(.systemGray))
                                }
                                Text("\(item.content ?? "")")
                                    .font(.system(size: 16, weight: .light, design: .rounded))
                                    .foregroundColor(Color(.systemGray))
                            }
                        }
                    }.frame(height: 50)
                }
            } else {
                HStack(alignment: .center) {
                    if !isChecked {
                        Button(action: {
                            isChecked = true
                            checkedSet.insert(item.id!.uuidString)
                        }, label: {
                            Image(systemName: "circle")
                                .imageScale(.large)
                                .foregroundColor(Color(.systemGray3))
                        })
                    } else {
                        Button(action: {
                            isChecked = false
                            checkedSet.remove(item.id!.uuidString)
                        }, label: {
                            Image(systemName: "checkmark.circle")
                                .imageScale(.large)
                                .foregroundColor(Color("buttonColor"))
                        })
                    }
                    VStack(alignment: .leading) {
                        Text("\(item.title!)")
                            .font(.system(size: 20, weight: .medium, design: .rounded))
                        HStack {
                            Text("\(item.timestamp!, formatter: itemFormatter)")
                                .font(.system(size: 16, weight: .light, design: .rounded))
                                .foregroundColor(Color(.systemGray))
                            Text("\(item.content!)")
                                .font(.system(size: 16, weight: .light, design: .rounded))
                                .foregroundColor(Color(.systemGray))
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

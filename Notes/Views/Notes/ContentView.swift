//
//  ContentView.swift
//  Notes
//
//  Created by alexis on 9/2/21.
//

import CoreData
import SwiftUI

struct ContentView: View {
    @ObservedObject var searchBar = SearchBar()

   

    @State var showListSheet = false
    @State var checkedSet = Set<String>()
    @State var selectable = false
    @State var isActive = false



    var body: some View {
        NotesList(selectable: $selectable, isActive: $isActive, checkedSet: $checkedSet, showListSheet: $showListSheet)
    }
}





//
//  ImagePickerSheet.swift
//  Notes
//
//  Created by alexis on 15/3/21.
//

import SwiftUI
import UIKit

struct ImagePickerSheet: View {
    @Binding var imageInCoordinator: Image?
    @State var isCoordinatorShown: Bool = false
    @State private var sourceType: UIImagePickerController.SourceType = .photoLibrary
    
    
    var body: some View {
        VStack {
            Button(action: {
                self.sourceType = .photoLibrary
                self.isCoordinatorShown.toggle()
            }, label: {
                HStack {
                    Text("Choose Photo or Video")
                    Image(systemName: "photo.on.rectangle")
                }
            })
            
            Button(action: {
                self.sourceType = .camera
                self.isCoordinatorShown.toggle()
            }, label: {
                HStack {
                    Text("Take Photo or Video")
                    Image(systemName: "camera")
                }
            })
        }
        .sheet(isPresented: $isCoordinatorShown) {
            ImagePickerView(
                isCoordinatorShown: $isCoordinatorShown,
                imageInCoordinator: $imageInCoordinator,
                sourceType: $sourceType
            )
        }
    }
}

//struct ImagePickerSheet_Previews: PreviewProvider {
//    static var previews: some View {
//        ImagePickerSheet()
//    }
//}

//
//  CaptureImage.swift
//  Notes
//
//  Created by alexis on 12/3/21.
//

import SwiftUI
import UIKit

struct ImagePickerView {
    @Binding var isCoordinatorShown: Bool
    @Binding var imageInCoordinator: Image?
    @Binding var sourceType: UIImagePickerController.SourceType

    func makeCoordinator() -> Coordinator {
      return Coordinator(isCoordinatorShown: $isCoordinatorShown, imageInCoordinator: $imageInCoordinator)
    }
}

extension ImagePickerView: UIViewControllerRepresentable {
    func makeUIViewController(context: UIViewControllerRepresentableContext<ImagePickerView>) -> UIImagePickerController {
            let picker = UIImagePickerController()
            picker.delegate = context.coordinator
            picker.sourceType = self.sourceType
            return picker
        }
    func updateUIViewController(_ uiViewController: UIImagePickerController, context: UIViewControllerRepresentableContext<ImagePickerView>)  {
        
    }
}

// image name => find the image file => read content =>
// image = [0101010010102301231203]
// "hello world" -> core
class Coordinator: NSObject, UINavigationControllerDelegate, UIImagePickerControllerDelegate {
    
    @Binding var isCoordinatorShown: Bool
    @Binding var imageInCoordinator: Image?
    
    
    // property -> argument name
    init(isCoordinatorShown: Binding<Bool>, imageInCoordinator: Binding<Image?>) {
            _isCoordinatorShown = isCoordinatorShown
            _imageInCoordinator = imageInCoordinator
        }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey: Any]) {
        guard let unwrapImage = info[UIImagePickerController.InfoKey.originalImage] as? UIImage
        else{return}
        imageInCoordinator = Image(uiImage: unwrapImage)
        isCoordinatorShown = false
    }
    
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        isCoordinatorShown = false
    }
}

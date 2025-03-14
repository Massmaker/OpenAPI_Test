//
//  ImagePickerView.swift
//  TestTask
//
//  Created by Ivan_Tests on 12.02.2025.
//


import SwiftUI
import UIKit


enum ImageSourceType:Identifiable {
    case camera
    case library
    
    var id:String {
        switch self {
        case .camera:
            "ImageSourceType_Camera"
        case .library:
            "ImageSourceType_Library"
        }
    }
    
    var uiKitSourceType:UIImagePickerController.SourceType {
        switch self {
        case .camera:
                .camera
        case .library:
                .photoLibrary
        }
    }
}


///ImagePickerView uses UIImagePicker to browse photolibrary or to take a new photo. No PhotoKit stuff is used.
struct ImagePickerView:UIViewControllerRepresentable {
    func makeCoordinator() -> Coordinator {
        return Self.Coordinator(parent: self)
    }
    
    private let sourceType:UIImagePickerController.SourceType
    @Environment(\.dismiss) private var dismissVar
    
    @Binding var imageSelected:UIImage?
    
    init(imageSource: ImageSourceType, imageSelected:Binding<UIImage?>) {
        self.sourceType = imageSource.uiKitSourceType
        self._imageSelected = imageSelected
    }
    
    func makeUIViewController(context: UIViewControllerRepresentableContext<ImagePickerView>) -> UIImagePickerController {
        let controller = UIImagePickerController()
        controller.allowsEditing = true
        
        //using some deprecated APIs instead of PHPicker
        #if targetEnvironment(simulator)
        controller.sourceType = .photoLibrary
        #else
        controller.sourceType = sourceType
        #endif
        
        controller.delegate = context.coordinator
    
        return controller
    }
    
    func updateUIViewController(_ uiViewController: UIImagePickerController, context: Context) {
        
    }
    
    
    fileprivate func setImage(_ image:UIImage) {
        //set to the client's binding
        self.imageSelected = image
        
        //dismiss from presentation
        dismissVar.callAsFunction()
    }
    
    class Coordinator:NSObject, UIImagePickerControllerDelegate, UINavigationControllerDelegate {
        var parent:ImagePickerView
        init(parent: ImagePickerView) {
            self.parent = parent
        }
        
        func imagePickerController( _ picker: UIImagePickerController,
                                    didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {

            if let edited = info[.editedImage] as? UIImage {
                //2 - User has finished image cropping( if needed )
                
                //delegate method called after user has edited image, – use edited image (probably cropped)
                #if DEBUG
                if let original = info[.originalImage] as? UIImage {
                    if let origData = original.jpegData(compressionQuality: 1.0) {
                        print("Original: \(origData.count) Bytes")
                    }
                }
                
                if let editedData = edited.jpegData(compressionQuality: 1) {
                    print("Edited: \(editedData.count) Bytes")
                }
                #endif
                
                parent.setImage(edited)
                return
            }
            
            guard let _ = info[.originalImage] else {
                //no image selected
                return
            }
            
            
            //1 - User has selected an image -> Proceed to image cropping
            
            // delegate method called after user has taken a new photo, – start editing the image to allow user to crop an image if needed
            picker.setEditing(true, animated: true)
        }
    }
    
    
}

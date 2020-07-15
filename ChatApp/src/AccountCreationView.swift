//
//  AccountCreation View.swift
//  ChatApp
//
//  Created by Tung on 15/07/2020.
//  Copyright © 2020 Tung. All rights reserved.
//

import SwiftUI

struct AccountCreationView: View {
    
    @State var picker = false
    @State var name = ""
    @State var image: Image?
    @State var inputImage: UIImage?
    
    var body: some View {
        
        VStack {
            Text("Create Account").font(.title)
            
            Button(action: {
                self.picker.toggle()
            }){
                if image == nil {
                    
                    Image(systemName: "person.crop.circle.badge.plus")
                    .resizable()
                    .frame(width: 90, height: 70)
                    .foregroundColor(.gray)
                
                } else {
                    image?
                    .resizable()
                    .frame(width: 90, height: 70)
                }
            }.sheet(isPresented: $picker, onDismiss: loadImage){
                ImagePicker(image: self.$inputImage)
              }
                
            Text("Enter User Name")
                .font(.body)
                .foregroundColor(.gray)
                .padding()
            
            TextField("Name", text: self.$name)
            .keyboardType(.numberPad)
            .frame(width: UIScreen.main.bounds.width - 30, height:50)
            .background(Color.gray)
            .cornerRadius(10)
            
            Button(action: {
                    
            }){
                Text("Create").frame(width: UIScreen.main.bounds.width - 30, height: 50)
            }.foregroundColor(.white)
                .background(Color.orange)
                .cornerRadius(10)
                .padding(.top, 15)
        }
    }
    
    func loadImage(){
    
        guard let input = inputImage else {
            return
        }

        image = Image(uiImage: input)
    }
}

struct Indicator : UIViewRepresentable {
    
    func makeUIView(context: UIViewRepresentableContext<Indicator>) -> UIActivityIndicatorView {
        
        let indicator = UIActivityIndicatorView(style: .large)
        indicator.startAnimating()
        
        return indicator
    }
    
    func updateUIView(_ uiView: UIActivityIndicatorView , context: UIViewRepresentableContext<Indicator>) {
        
    }
}

struct ImagePicker: UIViewControllerRepresentable {
    
    class Coordinator: NSObject, UINavigationControllerDelegate, UIImagePickerControllerDelegate {
        
        let parent: ImagePicker

        init(_ parent: ImagePicker) {
            self.parent = parent
        }
        
        func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
            
            if let uiImage = info[.originalImage] as? UIImage {
                parent.image = uiImage
            }
            
            parent.presentationMode.wrappedValue.dismiss()
        }
        
    }
    
    func makeCoordinator() -> Coordinator {
        Coordinator(self)
    }
    
    @Environment(\.presentationMode) var presentationMode
    @Binding var image: UIImage?
    
    func makeUIViewController(context: UIViewControllerRepresentableContext<ImagePicker>) -> UIImagePickerController {
        let picker = UIImagePickerController()
        picker.delegate = context.coordinator
        return picker
    }
    
    func updateUIViewController(_ uiViewController: UIImagePickerController, context: UIViewControllerRepresentableContext<ImagePicker>) {
        
    }
}


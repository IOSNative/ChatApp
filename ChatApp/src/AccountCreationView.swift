//
//  AccountCreation View.swift
//  ChatApp
//
//  Created by Tung on 15/07/2020.
//  Copyright © 2020 Tung. All rights reserved.
//

import SwiftUI
import FirebaseAuth
import FirebaseStorage
import FirebaseFirestore

struct AccountCreationView: View {
    
    @State var picker = false
    @State var name = ""
    @State var imgData : Data = .init(count: 0)
    @State var loading = false
    
    @Environment(\.presentationMode) var presentationMode
    
    var body: some View {
        
        VStack {
            Text("Create Account").font(.title)
            
            Button(action: {
                self.picker.toggle()
            }){
                if imgData.count == 0 {
                    
                    Image(systemName: "person.crop.circle.badge.plus")
                    .resizable()
                    .frame(width: 90, height: 70)
                    .foregroundColor(.gray)
                
                } else {
                    Image(uiImage: UIImage(data: imgData)!)
                    .renderingMode(.original) //load lại image
                    .resizable()
                    .frame(width: 90, height: 70)
                }
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
            
            if self.loading {
                
                HStack{
                    
                    Spacer()
                    
                    Indicator()
                    
                    Spacer()
                }
            } else {
                Button(action: {
                    
                    if self.name != "" {
                        createUser(name: self.name, imagedata: self.imgData) {
                            (status) in

                            if status {
                                //self.loading.toggle()
                                self.presentationMode.wrappedValue.dismiss()
                                
                                UserDefaults.standard.set(true, forKey: "status")

                                NotificationCenter.default.post(name: NSNotification.Name("statusChange"), object: nil)
                            }
                        }
                    }
                    
                }){
                    Text("Create").frame(width: UIScreen.main.bounds.width - 30, height: 50)
                }.foregroundColor(.white)
                    .background(Color.orange)
                    .cornerRadius(10)
                    .padding(.top, 15)
                .sheet(isPresented: $picker){
                  ImagePicker(imgData: self.$imgData)
                }
            }
        }
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
    
    @Binding var imgData: Data
    @Environment(\.presentationMode) var presentationMode
    
    class Coordinator: NSObject, UINavigationControllerDelegate, UIImagePickerControllerDelegate {
        
        let parent: ImagePicker

        init(_ parent: ImagePicker) {
            self.parent = parent
        }
        
        func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
            
            let uiImage = info[.originalImage] as? UIImage
            let data = uiImage?.jpegData(compressionQuality: 0.45)
            self.parent.imgData = data!
            
            parent.presentationMode.wrappedValue.dismiss()
        }
        
    }
    
    func makeCoordinator() -> Coordinator {
        Coordinator(self)
    }
    
    func makeUIViewController(context: UIViewControllerRepresentableContext<ImagePicker>) -> UIImagePickerController {
        let picker = UIImagePickerController()
        picker.delegate = context.coordinator
        return picker
    }
    
    func updateUIViewController(_ uiViewController: UIImagePickerController, context: UIViewControllerRepresentableContext<ImagePicker>) {
        
    }
}

func createUser(name: String,imagedata : Data,completion : @escaping (Bool)-> Void){
    let db = Firestore.firestore()
    
    let storage = Storage.storage().reference()
    
    let uid = Auth.auth().currentUser?.uid
    
    storage.child("profilepics").child(uid!).putData(imagedata, metadata: nil) { (_, err) in
        
        if err != nil {
            
            print((err?.localizedDescription)!)
            return
        }
        
        storage.child("profilepics").child(uid!).downloadURL { (url, err) in
            
            if err != nil {
                
                print((err?.localizedDescription)!)
                return
            }
            
            db.collection("users").document(uid!).setData(["name":name,"image":"\(url!)","uid":uid!]) { (err) in
                
                if err != nil{
                    
                    print((err?.localizedDescription)!)
                    return
                }
                
                completion(true)
            }
        }
    }
}


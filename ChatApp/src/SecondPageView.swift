//
//  SecondView.swift
//  ChatApp
//
//  Created by Tung on 15/07/2020.
//  Copyright © 2020 Tung. All rights reserved.
//

import SwiftUI
import FirebaseAuth
import FirebaseStorage
import FirebaseFirestore

struct SecondPageView: View {
    
    @Binding var show: Bool
    @Binding var ID: String
    
    @State var code = ""
    @State var mgs = ""
    @State var alert = false
    @State var loading = false
    
    var body: some View {
        
        ZStack(alignment: .topLeading)
        {
            GeometryReader { _ in
                VStack {
                    Image("message")
                        .resizable()
                        .frame(width: 100, height: 100, alignment: .center)
                    
                    Text("Verification Code")
                        .font(.largeTitle)
                        .fontWeight(.heavy)
                    
                    Text("Please enter the Verification Code")
                        .font(.body)
                        .foregroundColor(.gray)
                        .padding(.top, 10)
                        
                    TextField("Code", text: self.$code)
                    .keyboardType(.numberPad)
                    .padding()
                    .background(Color.gray)
                    .cornerRadius(10)
                        
                    if  self.loading {
                        HStack {
                            Spacer()
                            
                            Indicator()
                            
                            Spacer()
                        }
                    }
                    else {
                        Button(action: {
                            
                            self.loading.toggle()
                            
                            let credential =
                                PhoneAuthProvider.provider().credential(withVerificationID: self.ID, verificationCode: self.code)
                            
                            Auth.auth().signIn(with: credential) {
                                
                                (res, err) in
                                
                                if err != nil {
                                
                                    self.mgs = (err?.localizedDescription)!
                                    self.alert.toggle()
                                    return
                                
                                }
                                
                                UserDefaults.standard.set(true, forKey: "status")
                                
                                NotificationCenter.default.post(name: NSNotification.Name("statusChange"), object: nil)
                                
                                let db = Firestore.firestore()
                                //read
                                db.collection("users").getDocuments() { (querySnapshot, err) in
                                    if let err = err {
                                        print("Error getting documents: \(err)")
                                    } else {
                                        for document in querySnapshot!.documents {
                                            if document.data()["phoneNumber"] as? String == str {
                                                return
                                            }
                                        }
                                        
                                        addUser(phoneNumber: str!)
                                    }
                                }
                                
                            }
                        
                        }){
                            Text("Verify").frame(width: UIScreen.main.bounds.width - 30, height: 50)
                        }.foregroundColor(.white)
                            .background(Color.orange)
                            .cornerRadius(10)
                    }
                }
                
                Button(action: {
                    self.show.toggle()
                }){
                    Image(systemName: "chevron.left")
                        .font(.title)
                        .foregroundColor(.orange)
                }
                .alert(isPresented: self.$alert){
                    
                    Alert(title: Text("Error"), message: Text(self.mgs), dismissButton: .default(Text("OK")))
                    
                }
                
            }
        }
    }
}

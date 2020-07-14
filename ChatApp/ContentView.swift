//
//  ContentView.swift
//  ChatApp
//
//  Created by Tung on 12/07/2020.
//  Copyright © 2020 Tung. All rights reserved.
//

import SwiftUI
import FirebaseAuth
import FirebaseStorage
import FirebaseFirestore

var str: String?

struct ContentView: View {
    
    @State var status = UserDefaults.standard.value(forKey: "status") as? Bool ?? false
    
    var body: some View {
        
        VStack {
            
            if status {
                Home()
            }
            else {
                NavigationView {
                    FirstPage()
                }
            }
        }.onAppear {
            NotificationCenter.default.addObserver(forName: NSNotification.Name("statusChange"), object: nil, queue: .main){
                
                (_) in
                
                let status = UserDefaults.standard.value(forKey: "status") as? Bool ?? false
                
                self.status = status
            }
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}

struct FirstPage: View {
    
    @State var no = ""
    @State var code = ""
    @State var show = false
    @State var mgs = ""
    @State var alert = false
    @State var ID = ""
    
    var body: some View {
        VStack
        {
            Image("message")
                .resizable()
                .frame(width: 100, height: 100, alignment: .center)
            
            Text("Verifi your number")
                .font(.largeTitle)
                .fontWeight(.heavy)
            
            Text("Please enter your number To veryfi your account")
                .font(.body)
                .foregroundColor(.gray)
                .padding(.top, 10)
            
            HStack
            {
                
                TextField("+1", text: $no)
                .keyboardType(.numberPad)
                .padding()
                .frame(width: 70)
                .background(Color.gray)
                .cornerRadius(10)
                
                TextField("Number", text: $code)
                .keyboardType(.numberPad)
                .padding()
                .background(Color.gray)
                .cornerRadius(10)
                
            }.padding()
            
            NavigationLink(destination: SecondPage(show: $show, ID: $ID), isActive: $show)
            {
                    Button(action: {
                        
                        //remove Auth when testing with real phone number
                        Auth.auth().settings?.isAppVerificationDisabledForTesting = true
                        
                        PhoneAuthProvider.provider().verifyPhoneNumber("+" + self.no + self.code, uiDelegate: nil){
                            
                            (ID, err) in
                            
                            if err != nil {
                            
                                self.mgs = (err?.localizedDescription)!
                                self.alert.toggle()
                                return
                            
                            }

                            str = "+" + self.no + self.code
                            
                            self.ID = ID!
                            self.show.toggle()
                        }
                    }){
                        Text("Send").frame(width: UIScreen.main.bounds.width - 30, height: 50)
                    }.foregroundColor(.white)
                        .background(Color.orange)
                        .cornerRadius(10)
                        .navigationBarTitle("")
                        .navigationBarHidden(true)
                        .navigationBarBackButtonHidden(true)
            }.alert(isPresented: $alert){
                
                Alert(title: Text("Error"), message: Text(self.mgs), dismissButton: .default(Text("OK")))
                
            }
            
        }
    }
}
    
struct SecondPage: View
{
    
    @State var code = ""
    @Binding var show: Bool
    @Binding var ID: String
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
                                
                                addUser(phoneNumber: str!)
                                
                                self.loading.toggle()
                                
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

struct Home: View {
    var body: some View {
        
        VStack {
            
            Text("Welcome")
            
            Button(action: {
                try! Auth.auth().signOut()
                
                UserDefaults.standard.set(false,  forKey: "status")
                
                NotificationCenter.default.post(name: NSNotification.Name("statusChange"), object: nil)
            }){
                Text("Logout")
            }
            
        }
        
    }
}

func addUser(phoneNumber: String){
    let db = Firestore.firestore()
    
    //add
    db.collection("users").addDocument(data: [
        "phoneNumber": phoneNumber,
    ])
    
    //read
    db.collection("users").getDocuments() { (querySnapshot, err) in
        if let err = err {
            print("Error getting documents: \(err)")
        } else {
            for document in querySnapshot!.documents {
                print("\(document.data())")
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

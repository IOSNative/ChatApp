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
var checkUser: Bool = true

struct ContentView: View {
    
    @State var status = UserDefaults.standard.value(forKey: "status") as? Bool ?? false
    
    var body: some View {
        
//        VStack {
//
//            if status {
//                HomeView()
//            }
//            else {
//                NavigationView {
//                    FirstPageView()
//                }
//            }
//        }.onAppear {
//            NotificationCenter.default.addObserver(forName: NSNotification.Name("statusChange"), object: nil, queue: .main){
//
//                (_) in
//
//                let status = UserDefaults.standard.value(forKey: "status") as? Bool ?? false
//
//                self.status = status
//            }
//        }
        
        AccountCreationView()
        
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}

//struct FirstPage: View
//{
//
//    @State var no = ""
//    @State var code = ""
//    @State var show = false
//    @State var mgs = ""
//    @State var alert = false
//    @State var ID = ""
//
//    @State private var inputImage: UIImage?
//    @State private var showImage = false
//    @State private var imgData = Data(capacity: 0)
//    @State var image: Image?
//
//    var body: some View
//    {
//        VStack
//        {
//            //Image("message")
//
//            if image != nil {
//               // image = Image(uiImage: inputImage!)
//                 image?.resizable()
//                    .frame(width: 100, height: 100, alignment: .center)
//                .scaledToFit()
//            }
//
//            Text("Verifi your number")
//                .font(.largeTitle)
//                .fontWeight(.heavy)
//
//            Text("Please enter your number To veryfi your account")
//                .font(.body)
//                .foregroundColor(.gray)
//                .padding(.top, 10)
//
//            HStack
//            {
//
//                TextField("+1", text: $no)
//                .keyboardType(.numberPad)
//                .padding()
//                .frame(width: 70)
//                .background(Color.gray)
//                .cornerRadius(10)
//
//                TextField("Number", text: $code)
//                .keyboardType(.numberPad)
//                .padding()
//                .background(Color.gray)
//                .cornerRadius(10)
//
//            }.padding()
//
//            NavigationLink(destination: SecondPage(show: $show, ID: $ID), isActive: $show)
//            {
//                    Button(action: {
//                       self.showImage.toggle()
//                        //remove Auth when testing with real phone number
////                        Auth.auth().settings?.isAppVerificationDisabledForTesting = true
////
////                        PhoneAuthProvider.provider().verifyPhoneNumber("+" + self.no + self.code, uiDelegate: nil){
////
////                            (ID, err) in
////
////                            if err != nil {
////
////                                self.mgs = (err?.localizedDescription)!
////                                self.alert.toggle()
////                                return
////
////                            }
////
////                            str = "+" + self.no + self.code
////
////                            self.ID = ID!
////                            self.show.toggle()
//
//
//                    }){
//                        Text("Send").frame(width: UIScreen.main.bounds.width - 30, height: 50)
//                    }.foregroundColor(.white)
//                        .background(Color.orange)
//                        .cornerRadius(10)
//                        .navigationBarTitle("")
//                        .navigationBarHidden(true)
//                        .navigationBarBackButtonHidden(true)
//                        .sheet(isPresented: $showImage, onDismiss: loadImage){
//                            ImagePicker(image: self.$inputImage)
//                        }
//            }.alert(isPresented: $alert){
//
//                Alert(title: Text("Error"), message: Text(self.mgs), dismissButton: .default(Text("OK")))
//
//            }
//
//        }.onTapGesture {
//            self.showImage = true
//        }
//    }
//
//    func loadImage(){
//
//        guard let input = inputImage else {
//            return
//        }
//
//        image = Image(uiImage: input)
//    }
//
//}

func addUser(phoneNumber: String){
    let db = Firestore.firestore()

    //add
    db.collection("users").addDocument(data: [
        "uid": Auth.auth().currentUser?.uid ?? "",
        "phoneNumber": phoneNumber
    ])

}


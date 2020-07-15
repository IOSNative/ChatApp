//
//  TestView.swift
//  ChatApp
//
//  Created by Tung on 15/07/2020.
//  Copyright © 2020 Tung. All rights reserved.
//

import SwiftUI
import FirebaseAuth
import FirebaseStorage
import FirebaseFirestore

struct FirstPageView: View
{
    @State var no = ""
    @State var code = ""
    @State var show = false
    @State var mgs = ""
    @State var alert = false
    @State var ID = ""
            
    var body: some View
    {
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
            
            NavigationLink(destination: SecondPageView(show: $show, ID: $ID), isActive: $show)
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
                
            }.alert(isPresented: $alert){
                Alert(title: Text("Error"), message: Text(self.mgs), dismissButton: .default(Text("OK")))
            }
        }
    }
}

//
//  HomeView.swift
//  ChatApp
//
//  Created by Tung on 15/07/2020.
//  Copyright © 2020 Tung. All rights reserved.
//

import SwiftUI
import FirebaseAuth
import FirebaseStorage
import FirebaseFirestore

struct HomeView: View {
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

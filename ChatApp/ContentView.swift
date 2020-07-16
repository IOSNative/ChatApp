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
        
        VStack {

            if status {
                HomeView()
            }
            else {
                NavigationView {
                    FirstPageView()
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


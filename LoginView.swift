//
//  LoginView.swift
//  Habits
//
//  Created by Gavin Woffinden on 12/12/22.
//

import SwiftUI
import FirebaseCore
import FirebaseAuth
import FirebaseFirestore

struct LoginView: View {
    @EnvironmentObject var firestoreManager: FirestoreManager
    @Environment(\.dismiss) var dismiss
    @State var email = ""
    @State var password = ""
    @State var createOrLogin = false
    @State var authenticated = false
    
    var body: some View {
            VStack {
                Text("Habits")
                    .frame(maxWidth: 250, maxHeight: 55, alignment: .top)
                    .font(.system(size: 35))
                    .padding(.bottom, 25)
                
                VStack {
                    Text(self.createOrLogin ? "Create Account" : "User Login")
                        .font(.system(size: 22))
                    
                    TextField("Email:", text: self.$email)
                        .padding(.vertical, 20)
                        .padding(.leading, 20)
                        .font(.system(size: 20))
                        .textInputAutocapitalization(.never)
                    
                    TextField("Password", text: self.$password)
                        .padding(.vertical, 20)
                        .padding(.leading, 20)
                        .font(.system(size: 20))
                        .textInputAutocapitalization(.never)
                        .privacySensitive(true)
                    
                }.frame(maxWidth: UIScreen.main.bounds.width - 80, maxHeight: 250, alignment: .leading)
                    .overlay(
                        RoundedRectangle(cornerRadius: 15)
                            .stroke(.gray, lineWidth: 2)
                    )
                    .padding(.bottom, 40)
                Button {
                    self.createOrLogin ? Auth.auth().createUser(withEmail: email, password: password) : Auth.auth().signIn(withEmail: email, password: password) { authResult, error in
                        if (authResult != nil) {
                            print("Successfully signed in!")
                            Home.shared.goToLogin = false
                            self.dismiss()
                        }
                        if (error != nil) {
                            print("Error signing in")
                        }
                    }
                } label: {
                    Text(self.createOrLogin ? "Save >" : "Sign in >")
                        .font(.system(size: 20))
                }
                .padding(.leading, UIScreen.main.bounds.width / 2)
                .padding(.bottom, 40)
               
                Button {
                    self.createOrLogin.toggle()
                } label: {
                    Text(self.createOrLogin ? "Already have an account?\nLog in" : "Create an account")
                }
                .frame(maxWidth: UIScreen.main.bounds.width - 30, alignment: .center)
                
            }.frame(minHeight: UIScreen.main.bounds.height / 1.2, alignment: .top)
                .foregroundColor(.gray)
                .animation(.easeInOut, value: self.createOrLogin)
    }
}

struct LoginView_Previews: PreviewProvider {
    static var previews: some View {
        LoginView()
    }
}

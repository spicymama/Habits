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
   // @State var authenticated = false
    @State var staySignedIn = false
    
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
                    SecureTextFeild(text: self.$password)
                        .padding(.vertical, 20)
                        .padding(.leading, 20)
                  
                    
                }.frame(maxWidth: UIScreen.main.bounds.width - 80, maxHeight: 250, alignment: .leading)
                    .overlay(
                        RoundedRectangle(cornerRadius: 15)
                            .stroke(.gray, lineWidth: 2)
                    )
                    .padding(.bottom, 40)
                Button {
                    self.createOrLogin ? Auth.auth().createUser(withEmail: email, password: password) { authResult, error in
                        if (authResult != nil) {
                            print("Successfully created account!!")
                            Home.shared.goToLogin = false
                            self.dismiss()
                            UserDefaults.standard.set( authResult?.user.uid, forKey: "userID")
                            createUser(user: User(id: (authResult?.user.uid)!, email: self.email, password: self.password))
                        }
                        if (error != nil) {
                            print("Error creating account")
                        }
                    }
                    : Auth.auth().signIn(withEmail: email, password: password) { authResult, error in
                        if (authResult != nil) {
                            print("Successfully signed in!")
                            Home.shared.goToLogin = false
                            self.dismiss()
                        }
                        if (error != nil) {
                            print("Error signing in")
                        }
                    }
                    if staySignedIn == true {
                        let defaults = UserDefaults.standard
                        defaults.set(false, forKey: "goToLogin")
                        defaults.set(self.email, forKey: "email")
                        defaults.set(self.password, forKey: "password")
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
                Button {
                    staySignedIn.toggle()
                } label: {
                    HStack {
                        Text("Keep me signed in")
                        Image(systemName: staySignedIn ? "square.fill" : "square")
                    }
                }

                
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
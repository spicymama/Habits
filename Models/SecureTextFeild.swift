//
//  SecureTextFeild.swift
//  Habits
//
//  Created by Gavin Woffinden on 12/13/22.
//

import SwiftUI

struct SecureTextFeild: View {
        @FocusState var focus1: Bool
        @FocusState var focus2: Bool
        @State var showPassword: Bool = false
        @Binding var text: String
    var placeholder: String

    var body: some View {
            HStack {
                ZStack(alignment: .trailing) {
                    TextField(placeholder, text: $text)
                        .disableAutocorrection(true)
                        .autocapitalization(.none)
                        .textContentType(.password)
                        .font(.system(size: 20))
                        .focused($focus1)
                        .opacity(showPassword ? 1 : 0)
                    SecureField(placeholder, text: $text)
                        .disableAutocorrection(true)
                        .autocapitalization(.none)
                        .textContentType(.password)
                        .font(.system(size: 20))
                        .focused($focus2)
                        .opacity(showPassword ? 0 : 1)
                    Button(action: {
                        showPassword.toggle()
                        if showPassword { focus1 = true } else { focus2 = true }
                    }, label: {
                        Image(systemName: self.showPassword ? "eye.fill" : "eye.slash.fill" ).font(.system(size: 16, weight: .regular))
                            .padding()
                            .foregroundColor(.gray)
                    })
            }
        }
    }
}
/*
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
             UserDefaults.standard.set( authResult?.user.uid, forKey: "userID")
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
 */

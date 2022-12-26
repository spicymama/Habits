//
//  Settings.swift
//  Habits
//
//  Created by Gavin Woffinden on 12/26/22.
//

import SwiftUI
import FirebaseCore
import FirebaseAuth
import FirebaseFirestore

struct Settings: View {
    @Environment(\.dismiss) var dismiss
    var body: some View {
        ScrollView {
            Button {
                dismiss()
            } label: {
                Image(systemName: "xmark")
            }.frame(maxWidth: UIScreen.main.bounds.width - 60, alignment: .trailing)
                .foregroundColor(.gray)
            VStack {
                Text("Settings")
                    .frame(maxWidth: 250, maxHeight: 55, alignment: .top)
                    .font(.system(size: 35))
                    .foregroundColor(.gray)
                    .padding(.bottom, 25)
                Button {
                    logoutUser()
                    self.dismiss()
                } label: {
                    Text("Sign Out")
                        .foregroundColor(.red)
                }
                
            }
        }
    }
}

struct Settings_Previews: PreviewProvider {
    static var previews: some View {
        Settings()
    }
}
func logoutUser() {
    do { try Auth.auth().signOut() }
    catch { print("already logged out") }
    let defaults = UserDefaults.standard
    defaults.set(true, forKey: "goToLogin")
    defaults.set("", forKey: "email")
    defaults.set("", forKey: "password")
}

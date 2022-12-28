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
    @State var backgroundColor = Color.white
    @State var foregroundColor = Color.gray
    @State var accentColor = Color.gray
    @State var fontSize = 12.0
    @State private var isEditing = false
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
                    .foregroundColor(foregroundColor)
                    .padding(.bottom, 25)
                
                VStack {
                    SquareColorPicker(colorValue: $backgroundColor, title: "Choose background color")
                   SquareColorPicker(colorValue: $foregroundColor, title: "Choose foreground color")
                    SquareColorPicker(colorValue: $accentColor, title: "Choose accent color")
                }
                .frame(maxWidth: UIScreen.main.bounds.width / 1.2, alignment: .center)
                .padding()
                .foregroundColor(foregroundColor)
                .tint(accentColor)
                VStack {
                    Text("Font Size")
                        .font(.system(size: fontSize))
                        
                    Slider(value: self.$fontSize,
                           in: 12...40,
                           onEditingChanged: { editing in
                        isEditing = editing
                        
                    })
                    .frame(maxWidth: UIScreen.main.bounds.width / 1.2, alignment: .center)
                }
                .padding()
                .foregroundColor(foregroundColor)
                .tint(accentColor)
                Button {
                    let defaults = UserDefaults.standard
                    defaults.set(fontSize, forKey: "fontSize")
                    defaults.set(backgroundColor, forKey: "backgroundColor")
                    defaults.set(foregroundColor, forKey: "foregroundColor")
                    defaults.set(accentColor, forKey: "accentColor")
                } label: {
                    Text("Save")
                        .foregroundColor(foregroundColor)
                        .font(.system(size: 23))
                }.padding(.top, 80)
                Button {
                    logoutUser()
                    self.dismiss()
                } label: {
                    Text("Sign Out")
                        .foregroundColor(.red)
                }.padding(.top, 40)
                
            }
        }
        .frame(width: UIScreen.main.bounds.width)
        .background(backgroundColor)
        .tint(accentColor)
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

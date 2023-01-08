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
import UserNotifications
import UIKit

struct Settings: View {
    static let shared = Settings()
    @Environment(\.dismiss) var dismiss
    @StateObject var prefs = DisplayPreferences()
    @State var fontSize = UserDefaults.standard.value(forKey: "fontSize") as? Double ?? 15.0
    @State var headerFontSize = UserDefaults.standard.value(forKey: "headerFontSize") as? Double ?? 35.0
    @State var titleFontSize = UserDefaults.standard.value(forKey: "titleFontSize") as? Double ?? 25.0
    @State var backgroundColor = Color(uiColor: UserDefaults.standard.color(forKey: "backgroundColor") ?? .white)
    @State var foregroundColor = Color(uiColor: UserDefaults.standard.color(forKey: "foregroundColor") ?? .gray)
    @State var accentColor = Color(uiColor: UserDefaults.standard.color(forKey: "accentColor") ?? .gray)
    @State private var isEditing = false
    @State private var isEditing2 = false
    @State private var isEditing3 = false
    @State var colorTap = false
    @State var fontTap = false
    @State var showSaveButton = false
    @State var goToLogin = false
    @State var deleteAccTap = false
    var body: some View {
        ScrollView {
            Button {
                dismiss()
            } label: {
                Image(systemName: "xmark")
            }.frame(maxWidth: UIScreen.main.bounds.width - 60, alignment: .trailing)
                .foregroundColor(accentColor)
            
            VStack {
                Text("Settings")
                    .frame(maxWidth: 250, maxHeight: 55, alignment: .top)
                    .font(.system(size: headerFontSize))
                    .foregroundColor(foregroundColor)
                    .padding(.bottom, 25)
                
                VStack {
                    self.colorTap ? Button {
                        self.colorTap = false
                    } label: {
                        Image(systemName: "xmark.circle")
                            .imageScale(.large)
                            .foregroundColor(accentColor)
                    }
                    .padding(.leading, UIScreen.main.bounds.width / 1.6) : nil
                Text("Choose Display Colors")
                    .foregroundColor(foregroundColor)
                    .font(.system(size: titleFontSize))
                    .frame(maxWidth: UIScreen.main.bounds.width / 1.2, maxHeight: .infinity)
                    
                    .onTapGesture {
                        self.colorTap = true
                        self.showSaveButton = true
                    }
                   
                
                    self.colorTap ? SquareColorPicker(colorValue: $backgroundColor, title: "Choose background color") : nil
                    self.colorTap ? SquareColorPicker(colorValue: $foregroundColor, title: "Choose foreground color") : nil
                    self.colorTap ? SquareColorPicker(colorValue: $accentColor, title: "Choose accent color") : nil
                }
                .frame(maxWidth: UIScreen.main.bounds.width / 1.45)
                .frame(minHeight: 40)
                .padding()
                .foregroundColor(foregroundColor)
                .tint(accentColor)
                .overlay(
                    RoundedRectangle(cornerRadius: 15)
                        .stroke(self.foregroundColor, lineWidth: 2)
                )
                .animation(.easeInOut(duration: 1), value: self.colorTap)
                VStack {
                    self.fontTap ? Button {
                        self.fontTap = false
                    } label: {
                        Image(systemName: "xmark.circle")
                            .imageScale(.large)
                            .foregroundColor(self.accentColor)
                    }
                    .padding(.leading, UIScreen.main.bounds.width / 1.6)
                    .padding(.top) : nil
                    Text("Set Font Size")
                        .font(.system(size: titleFontSize))
                        .padding(.vertical)
                    self.fontTap ? VStack {
                        Text("Header Font Size")
                            .font(.system(size: headerFontSize))
                        Slider(value: self.$headerFontSize,
                               in: 12...40,
                               onEditingChanged: { editing in
                            isEditing = editing
                            if isEditing == false {
                                self.showSaveButton = true
                            }
                        })
                        .frame(maxWidth: UIScreen.main.bounds.width / 1.2, alignment: .center)
                    }
                    .padding()
                    .foregroundColor(foregroundColor)
                    .tint(accentColor) : nil
                    self.fontTap ? VStack {
                        Text("Title Font Size")
                            .font(.system(size: titleFontSize))
                        
                        Slider(value: self.$titleFontSize,
                               in: 12...40,
                               onEditingChanged: { editing in
                            isEditing2 = editing
                            if isEditing2 == false {
                                self.showSaveButton = true
                            }
                        })
                        .frame(maxWidth: UIScreen.main.bounds.width / 1.2, alignment: .center)
                    }
                    .padding()
                    .foregroundColor(foregroundColor)
                    .tint(accentColor) : nil
                    self.fontTap ? VStack {
                        Text("General Font Size")
                            .font(.system(size: fontSize))
                        
                        Slider(value: self.$fontSize,
                               in: 12...40,
                               onEditingChanged: { editing in
                            isEditing3 = editing
                            if isEditing3 == false {
                                self.showSaveButton = true
                            }
                        })
                        .frame(maxWidth: UIScreen.main.bounds.width / 1.2, alignment: .center)
                    }
                    .padding()
                    .foregroundColor(foregroundColor)
                    .tint(accentColor) : nil
                }
                .frame(maxWidth: UIScreen.main.bounds.width / 1.3)
                .frame(minHeight: 65)
                .foregroundColor(foregroundColor)
                .tint(accentColor)
                .overlay(
                    RoundedRectangle(cornerRadius: 15)
                        .stroke(self.foregroundColor, lineWidth: 2)
                )
                .padding(.top, 25)
                .animation(.easeInOut(duration: 1), value: self.colorTap)
                .animation(.easeInOut(duration: 1), value: self.fontTap)
                .onTapGesture {
                    self.fontTap = true
                }
             
                self.showSaveButton ? Button {
                    let defaults = UserDefaults.standard
                    defaults.set(fontSize, forKey: "fontSize")
                    defaults.set(headerFontSize, forKey: "headerFontSize")
                    defaults.set(titleFontSize, forKey: "titleFontSize")
                    defaults.set(UIColor(backgroundColor), forKey: "backgroundColor")
                    defaults.set(UIColor(foregroundColor), forKey: "foregroundColor")
                    defaults.set(UIColor(accentColor), forKey: "accentColor")
                    prefs.fontSize = fontSize
                    prefs.headerFontSize = headerFontSize
                    prefs.titleFontSize = titleFontSize
                    prefs.foregroundColor = foregroundColor
                    prefs.backgroundColor = backgroundColor
                    prefs.accentColor = accentColor
                    self.dismiss()
                } label: {
                    Text("Save Changes")
                        .foregroundColor(foregroundColor)
                        .font(.system(size: fontSize))
                }.padding(.top, 40) : nil
                Button {
                    logoutUser()
                    self.goToLogin = true
                    UserDefaults.standard.set(1, forKey: "goToLogin")
                } label: {
                    Text("Sign Out")
                        .foregroundColor(.red)
                        .font(.system(size: fontSize))
                }.padding(.top, 30)
                Button {
                    if deleteAccTap == true {
                        deleteAccount()
                        self.goToLogin = true
                        UserDefaults.standard.set(1, forKey: "goToLogin")
                    }
                    self.deleteAccTap = true
                } label: {
                    Text(self.deleteAccTap ? "Confirm Account Delete" : "Delete Account")
                        .foregroundColor(.red)
                        .font(.system(size: fontSize))
                }.padding(.top, 30)
            }
            .fullScreenCover(isPresented: self.$goToLogin) {
                LoginView()
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
    defaults.set(1, forKey: "goToLogin")
    defaults.set("", forKey: "email")
    defaults.set("", forKey: "password")
}
func deleteAccount() {
    guard let currentUser = UserDefaults.standard.value(forKey: "userID") as? String else { return }
    let db = Firestore.firestore()
    let docRef = db.collection("User").document(currentUser)
    let user = Auth.auth().currentUser
    docRef.delete() { err in
        if let err = err {
            print("Error removing document: \(err)")
        }
        else {
            user?.delete { error in
                if let error = error {
                    print("Error deleting account \(error)")
                } else {
                    print("Account deleted")
                }
            }
            print("Document successfully removed!")
        }
    }
}

extension UserDefaults {
    func color(forKey key: String) -> UIColor? {
        guard let colorData = data(forKey: key) else { return nil }
        do {
            return try NSKeyedUnarchiver.unarchivedObject(ofClass: UIColor.self, from: colorData)
        } catch let error {
            print("color error \(error.localizedDescription)")
            return nil
        }
    }
    func set(_ value: UIColor?, forKey key: String) {
        guard let color = value else { return }
        do {
            let data = try NSKeyedArchiver.archivedData(withRootObject: color, requiringSecureCoding: false)
            set(data, forKey: key)
        } catch let error {
            print("error color key data not saved \(error.localizedDescription)")
        }
    }
}

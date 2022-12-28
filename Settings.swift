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

struct Settings: View {
    @Environment(\.dismiss) var dismiss
    @State var backgroundColor = Color.white
    @State var foregroundColor = Color.gray
    @State var accentColor = Color.gray
    @State var fontSize = 15.0
    @State var headerFontSize = 35.0
    @State var titleFontSize = 25.0
    @State private var isEditing = false
    @State private var isEditing2 = false
    @State private var isEditing3 = false
    @State var colorTap = false
    @State var fontTap = false
    @State var showSaveButton = false
    @State var notifsAllowed = notifsAuthorized()
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
                    .font(.system(size: headerFontSize))
                    .foregroundColor(foregroundColor)
                    .padding(.bottom, 25)
                
                VStack {
                    self.colorTap ? Button {
                        self.colorTap = false
                    } label: {
                        Image(systemName: "xmark.circle")
                            .imageScale(.large)
                            .foregroundColor(Color(UIColor.systemGray4))
                    }
                    .padding(.leading, UIScreen.main.bounds.width / 1.6) : nil
                Text("Choose Display Colors")
                    .foregroundColor(foregroundColor)
                    .font(.system(size: 25))
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
                        .stroke(.gray, lineWidth: 2)
                )
                .animation(.easeInOut(duration: 1), value: self.colorTap)
                VStack {
                    self.fontTap ? Button {
                        self.fontTap = false
                    } label: {
                        Image(systemName: "xmark.circle")
                            .imageScale(.large)
                            .foregroundColor(Color(UIColor.systemGray4))
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
                        .stroke(.gray, lineWidth: 2)
                )
                .padding(.top, 25)
                .animation(.easeInOut(duration: 1), value: self.colorTap)
                .animation(.easeInOut(duration: 1), value: self.fontTap)
                .onTapGesture {
                    self.fontTap = true
                }
                notifsAuthorized() ? nil : HStack {
                    Button("Allow Notifications") {
                    self.notifsAllowed.toggle()
                    }
                    Image(systemName: self.notifsAllowed ? "square.fill" : "square")
                }
                .foregroundColor(foregroundColor)
                .font(.system(size: fontSize))
                .tint(accentColor)
                .padding(.top, 25)
                .onTapGesture {
                    self.notifsAllowed.toggle()
                }
                self.showSaveButton ? Button {
                    let defaults = UserDefaults.standard
                    defaults.set(fontSize, forKey: "fontSize")
                    defaults.set(headerFontSize, forKey: "headerFontSize")
                    defaults.set(titleFontSize, forKey: "titleFontSize")
                    defaults.set(backgroundColor, forKey: "backgroundColor")
                    defaults.set(foregroundColor, forKey: "foregroundColor")
                    defaults.set(accentColor, forKey: "accentColor")
                    if notifsAuthorized() == false && self.notifsAllowed == true {
                        UNUserNotificationCenter.current().requestAuthorization(options: [.alert, .badge, .sound]) { success, error in
                            if success {
                                print("All set!")
                            } else if let error = error {
                                print(error.localizedDescription)
                            }
                        }
                    }
                } label: {
                    Text("Save Changes")
                        .foregroundColor(foregroundColor)
                        .font(.system(size: fontSize))
                }.padding() : nil
                Button {
                    logoutUser()
                    self.dismiss()
                } label: {
                    Text("Sign Out")
                        .foregroundColor(.red)
                        .font(.system(size: fontSize))
                }.padding(.top, 20)
                
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
func notifsAuthorized()-> Bool {
    let currentNotification = UNUserNotificationCenter.current()
    var returnBool = false
    currentNotification.getNotificationSettings(completionHandler: { (settings) in
       if settings.authorizationStatus == .notDetermined {
         returnBool = false
       } else if settings.authorizationStatus == .denied {
         returnBool = false
       } else if settings.authorizationStatus == .authorized {
          returnBool = true
       }
    })
    return returnBool
}

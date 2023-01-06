//
//  LaunchScreen.swift
//  Habits
//
//  Created by Gavin Woffinden on 1/5/23.
//

import SwiftUI
import UIKit
import FirebaseCore
import FirebaseAuth
import FirebaseFirestore

struct LaunchScreen: View {
    @EnvironmentObject var firestoreManager: FirestoreManager
    @Environment(\.refresh) var refresh
    @ObservedObject var db = Database()
    @State var goToLogin = false
    @State var goHome = false
    
    var body: some View {
        NavigationStack {
            self.goToLogin || self.goHome ? nil :
            VStack {
                Text("Habits")
                    .foregroundColor(.gray)
                    .font(.system(size: 50))
                LoadingIcon()
                    .frame(width: 100, height: 100)
                    .padding(.vertical, 20)
                Text("Take control of what guides your life.")
                    .foregroundColor(.gray)
                    .italic()
                    .padding(.top)
            }.onAppear {
                let defaults = UserDefaults.standard
                // defaults.removeObject(forKey: "goToLogin")
                if defaults.value(forKey: "goToLogin") == nil {
                    defaults.set(1, forKey: "goToLogin")
                    self.goToLogin = true
                }
                else if defaults.value(forKey: "goToLogin") as! Int == 0 {
                    defaults.set(1, forKey: "goToLogin")
                    self.goToLogin = true
                }
                else if defaults.value(forKey: "goToLogin") as! Int == 1 {
                    self.goToLogin = true
                }
                else if defaults.value(forKey: "goToLogin") as! Int == 2 {
                    Auth.auth().signIn(withEmail: UserDefaults.standard.value(forKey: "email") as! String, password: UserDefaults.standard.value(forKey: "password") as! String) { authResult, error in
                        if (authResult != nil) {
                            db.fetchForRefresh()
                            self.goHome = true
                            print("Successfully signed in!")
                        } else {
                            defaults.set(1, forKey: "goToLogin")
                            self.goToLogin = true
                        }
                    }
                }
            }
            NavigationLink(isActive: self.$goToLogin, destination: {
                LoginView()
                    .onDisappear {
                        self.goHome = true
                    }
            }, label: {
                Text("")
            }).labelsHidden()
            
            NavigationLink(isActive: self.$goHome, destination: {
                Home()
            }, label: {
                Text("")
            }).labelsHidden()
                .navigationBarBackButtonHidden()
        }
    }
}

struct LaunchScreen_Previews: PreviewProvider {
    static var previews: some View {
        LaunchScreen()
    }
}

struct LoadingIcon: View {
    let style = StrokeStyle(lineWidth: 6, lineCap: .round)
    @State var animate = false
    let color1 = Color.gray
    let color2 = Color.white
    var body: some View {
        ZStack {
            Circle()
                .trim(from: 0, to: 0.7)
                .stroke( AngularGradient(gradient: .init(colors: [color1, color2]), center: .center), style: style)
                .rotationEffect(Angle(degrees: animate ? 360 : 0))
                .animation(Animation.linear(duration: 1.2).repeatForever(autoreverses: false), value: animate)
        }.onAppear {
            self.animate.toggle()
        }
    }
}

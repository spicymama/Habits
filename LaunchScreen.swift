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
    @ObservedObject var prefs = DisplayPreferences()
    @State var goToLogin = false
    @State var goHome = false
    @State var animate = true
    
    var body: some View {
        NavigationStack {
            self.goToLogin || self.goHome ? nil :
            VStack {
                Text("Habits")
                    .foregroundColor(prefs.foregroundColor)
                    .font(.system(size: 50))
                    .padding(.bottom, 20)
                LoadingSpinner(animate: self.$animate)
                    .frame(width: 100, height: 100)
                Text("Take control of what guides your life.")
                    .foregroundColor(prefs.foregroundColor)
                    .italic()
                    .padding(.top, 20)
            }
            .onAppear {
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
struct LoadingSpinner: UIViewRepresentable {
@Binding var animate: Bool
    func makeUIView(context: UIViewRepresentableContext<LoadingSpinner>) -> UIActivityIndicatorView {
        return UIActivityIndicatorView(style: .large)
    }
    func updateUIView(_ uiView: UIActivityIndicatorView, context: UIViewRepresentableContext<LoadingSpinner>) {
        uiView.startAnimating()
    }
}

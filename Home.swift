//
//  Home.swift
//  Habits
//
//  Created by Gavin Woffinden on 11/13/22.
//

import SwiftUI
import UIKit
import FirebaseCore
import FirebaseAuth
import FirebaseFirestore

struct Home: View {
    @EnvironmentObject var firestoreManager: FirestoreManager
    @Environment(\.refresh) var refresh
    @ObservedObject var appState = AppState.shared
    @ObservedObject var db = Database()
    //@StateObject var prefs = DisplayPreferences()
    static var shared = Home()
    @State private var addButtonTap = false
   // @State var tiles = Database().$tiles
    @State var goToLogin = UserDefaults.standard.bool(forKey: "goToLogin")
    @State var notificationTap = false
    @State var settingsTap = false
    @State var tileDrag: Tile?
    @State var hideTiles = false
    var padToggle = true
    var pushNavigationBinding : Binding<Bool> {
        .init { () -> Bool in
            appState.navigateTo != nil
        } set: { (newValue) in
            if !newValue { appState.navigateTo = nil }
        }
    }
    var body: some View {
        ScrollView {
            VStack {
                VStack {
                    HStack {
                        Button {
                            settingsTap = true
                            hideTiles = true
                        } label: {
                            Image(systemName: "gearshape")
                                .imageScale(.large)
                        }
                        .frame(maxWidth: 15, maxHeight: 15, alignment: .topLeading)
                        .foregroundColor(DisplayPreferences().accentColor)
                        .padding(.trailing)
                        .padding(.leading, 30)
                        .fullScreenCover(isPresented: $settingsTap, onDismiss: didDismiss) {
                            Settings()
                        }
                        Button {
                            notificationTap = true
                            hideTiles = true
                        } label: {
                            Image(systemName: db.newNotifs ? "bell.badge" : "bell")
                                .imageScale(.large)
                        }
                        .frame(maxWidth: 15, maxHeight: 15, alignment: .topLeading)
                        .foregroundColor(DisplayPreferences().accentColor)
                        .fullScreenCover(isPresented: $notificationTap, onDismiss: didDismiss) {
                            NotificationsView()
                        }
                        Button {
                            EditHabit.editGoal = false
                            addButtonTap = true
                            hideTiles = true
                        } label: {
                            Image(systemName: "plus.square")
                                .imageScale(.large)
                        }.fullScreenCover(isPresented: $addButtonTap, onDismiss: didDismiss) {
                            EditHabit()
                        }
                        .frame(maxWidth: 15, maxHeight: 15, alignment: .topTrailing)
                        .padding(.leading, UIScreen.main.bounds.width - 135)
                        .foregroundColor(DisplayPreferences().accentColor)
                    }
                    
                    Text("Habits")
                        .frame(maxWidth: 250, maxHeight: 55, alignment: .top)
                        .font(.system(size: DisplayPreferences().headerFontSize))
                        .foregroundColor(DisplayPreferences().foregroundColor)
                        .padding(.bottom, 25)
                }
                self.hideTiles ? nil : ForEach(db.tiles, id: \.id) { tile in
                        tile
                            .onDrag {
                                tileDrag = tile
                                return NSItemProvider()
                            }
                            .onDrop(of: [.item], delegate: DropViewDelegate(currentItem: tile, items: $db.tiles, draggingItem: $tileDrag, startIndex: db.tiles.firstIndex(of: tile)!))
                    }.frame(maxHeight: .infinity)
               !db.doneTiles.isEmpty ? Text("History")
                    .frame(maxWidth: 250, maxHeight: 55, alignment: .top)
                    .font(.system(size: DisplayPreferences().headerFontSize))
                    .foregroundColor(DisplayPreferences().foregroundColor)
                    .padding(.top, 50): nil
                self.hideTiles ? nil : ForEach(db.doneTiles, id: \.id) { tile in
                        tile
                            .onDrag {
                                tileDrag = tile
                                return NSItemProvider()
                            }
                            .onDrop(of: [.item], delegate: DropViewDelegate(currentItem: tile, items: $db.doneTiles, draggingItem: $tileDrag, isDone: true, startIndex: db.doneTiles.firstIndex(of: tile)!))
                    }.frame(maxHeight: .infinity)
            }
        }.frame(maxWidth: .infinity)
            .background(DisplayPreferences().backgroundColor)
            .onAppear() {
                let defaults = UserDefaults.standard
                if defaults.bool(forKey: "goToLogin").description.isEmpty {
                    defaults.set(true, forKey: "goToLogin")
                }
                if defaults.bool(forKey: "goToLogin") == false {
                    Auth.auth().signIn(withEmail: UserDefaults.standard.value(forKey: "email") as! String, password: UserDefaults.standard.value(forKey: "password") as! String) { authResult, error in
                        if (authResult != nil) {
                            print("Successfully signed in!")
                        } else {
                            defaults.set(true, forKey: "goToLogin")
                        }
                    }
                    db.fetchForRefresh()
                }
            }
            .fullScreenCover(isPresented: $goToLogin) {
                LoginView()
            }
            .refreshable {
                db.fetchForRefresh()
            }
            .fullScreenCover(isPresented: pushNavigationBinding) {
                NotificationsView()
            }
    }
    func didDismiss() {
        db.fetchForRefresh()
        self.hideTiles = false
    }
}

struct Home_Previews: PreviewProvider {
    static var previews: some View {
        Home()
            .environmentObject(FirestoreManager())
    }
}

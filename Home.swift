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
   // @StateObject var prefs = DisplayPreferences()
    static var shared = Home()
    @State private var addButtonTap = false
   // @State var fontSize = UserDefaults.standard.value(forKey: "fontSize") as? Double ?? 15.0
   // @State var headerFontSize = UserDefaults.standard.value(forKey: "headerFontSize") as? Double ?? 35.0
   // @State var titleFontSize = UserDefaults.standard.value(forKey: "titleFontSize") as? Double ?? 25.0
    //@State var backgroundColor = Color(uiColor: UserDefaults.standard.color(forKey: "backgroundColor") ?? .white)
    //@State var foregroundColor = Color(uiColor: UserDefaults.standard.color(forKey: "foregroundColor") ?? .gray)
    //@State var accentColor = Color(uiColor: UserDefaults.standard.color(forKey: "accentColor") ?? .gray)
   // @State var categoryArr: [String] = []
    @State var goToLogin = UserDefaults.standard.bool(forKey: "goToLogin")
    @State var notificationTap = false
    @State var newNotifs = false
    @State var settingsTap = false
    @State var tileDrag: Tile?
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
                            } label: {
                                Image(systemName: "gearshape")
                                    .imageScale(.large)
                            }
                            .frame(maxWidth: 15, maxHeight: 15, alignment: .topLeading)
                            .foregroundColor(DisplayPreferences().accentColor)
                            .padding(.trailing)
                            .padding(.leading, 30)
                            .fullScreenCover(isPresented: $settingsTap, onDismiss: fetchForRefresh) {
                                Settings()
                            }
                            Button {
                                notificationTap = true
                            } label: {
                                Image(systemName: newNotifs ? "bell.badge" : "bell")
                                    .imageScale(.large)
                            }
                            .frame(maxWidth: 15, maxHeight: 15, alignment: .topLeading)
                            .foregroundColor(DisplayPreferences().accentColor)
                            .fullScreenCover(isPresented: $notificationTap, onDismiss: fetchForRefresh) {
                                NotificationsView()
                            }
                            Button {
                                EditHabit.editGoal = false
                                addButtonTap = true
                            } label: {
                                Image(systemName: "plus.square")
                                    .imageScale(.large)
                            }.fullScreenCover(isPresented: $addButtonTap, onDismiss: fetchForRefresh) {
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
                    if !db.tiles.isEmpty {
                        ForEach(db.tiles, id: \.id) { tile in
                            tile
                                .padding(.top, 20)
                                .onDrag {
                                    tileDrag = tile
                                    return NSItemProvider()
                                }
                                .onDrop(of: [.item], delegate: DropViewDelegate(currentItem: tile, items: $db.tiles, draggingItem: $tileDrag, startIndex: db.tiles.firstIndex(of: tile)!))
                        }.frame(maxHeight: .infinity)
                    }
                    !db.doneTiles.isEmpty ? Text("History")
                        .frame(maxWidth: 250, maxHeight: 55, alignment: .top)
                        .font(.system(size: DisplayPreferences().headerFontSize))
                        .foregroundColor(DisplayPreferences().foregroundColor)
                        .padding(.top, 50): nil
                    if !db.doneTiles.isEmpty {
                        ForEach(db.doneTiles, id: \.id) { tile in
                            tile
                                .padding(.top, 20)
                                .onDrag {
                                    tileDrag = tile
                                    return NSItemProvider()
                                }
                                .onDrop(of: [.item], delegate: DropViewDelegate(currentItem: tile, items: $db.doneTiles, draggingItem: $tileDrag, isDone: true, startIndex: db.doneTiles.firstIndex(of: tile)!))
                        }.frame(maxHeight: .infinity)
                    }
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
                    fetchForRefresh()
                }
            }
            .fullScreenCover(isPresented: $goToLogin) {
                LoginView()
            }
        .refreshable {
            fetchForRefresh()
        }
        .fullScreenCover(isPresented: pushNavigationBinding) {
            NotificationsView()
        }
    }
    func formatTiles()-> () {
      //  UserDefaults.standard.removeObject(forKey: "tileOrder")
      //  UserDefaults.standard.removeObject(forKey: "doneTileOrder")
        var tileArr: [Tile] = []
        var doneTileArr: [Tile] = []
        db.tiles = []
        db.doneTiles = []
        let tileOrder = UserDefaults.standard.value(forKey: "tileOrder") as? [String] ?? []
        let doneTileOrder = UserDefaults.standard.value(forKey: "doneTileOrder") as? [String] ?? []
        for goal in db.goalArr {
            if goal.category == "" {
                if goal.endDate < Date.now || goal.prog >= 100.0 {
                    doneTileArr.append(Tile(id: goal.id, goalTile: GoalTile(goal: goal, isDone: true)))
                    db.doneTiles.append(Tile(id: goal.id, goalTile: GoalTile(goal: goal, isDone: true)))
                } else {
                    tileArr.append(Tile(id: goal.id, goalTile: GoalTile(goal: goal)))
                    db.tiles.append(Tile(id: goal.id, goalTile: GoalTile(goal: goal)))
                }
            }
        }
        for cat in db.catArr {
            var goals: [Goal] = []
            var doneCount = 0
            for goal in db.goalArr {
                if goal.category == cat {
                    goals.append(goal)
                }
                if goal.endDate < Date.now || goal.prog >= 100.0 {
                    doneCount += 1
                }
            }
            if doneCount == goals.count {
                db.doneTiles.append(Tile(id: cat, listTile: ListTile(goalArr: goals, isDone: true)))
                doneTileArr.append(Tile(id: cat, listTile: ListTile(goalArr: goals, isDone: true)))
            } else {
                db.tiles.append(Tile(id: cat, listTile: ListTile(goalArr: goals)))
                tileArr.append(Tile(id: cat, listTile: ListTile(goalArr: goals)))
            }
        }
        if !tileOrder.isEmpty {
            db.tiles = []
            for uid in tileOrder {
                for tile in tileArr {
                    if tile.id == uid {
                        db.tiles.append(tile)
                    }
                }
            }
        }
        if !doneTileOrder.isEmpty {
            db.doneTiles = []
            for uid in doneTileOrder {
                for tile in doneTileArr {
                    if tile.id == uid {
                        db.doneTiles.append(tile)
                    }
                }
            }
        }
        print("TILE ORDER: \(tileOrder)")
        print("DONE TILE ORDER: \(doneTileOrder)")
    }
    func fetchForRefresh() {
       // self.fontSize = UserDefaults.standard.value(forKey: "fontSize") as? Double ?? 15.0
       // self.headerFontSize = UserDefaults.standard.value(forKey: "headerFontSize") as? Double ?? 35.0
       // self.titleFontSize = UserDefaults.standard.value(forKey: "titleFontSize") as? Double ?? 25.0
       // self.backgroundColor = Color(uiColor: UserDefaults.standard.color(forKey: "backgroundColor") ?? .white)
       // self.foregroundColor = Color(uiColor: UserDefaults.standard.color(forKey: "foregroundColor") ?? .gray)
       // self.accentColor = Color(uiColor: UserDefaults.standard.color(forKey: "accentColor") ?? .gray)
        fetchAllGoals { goals in
            db.catArr = []
            db.goalArr = []
            db.goalArr.append(contentsOf: goals)
            for i in goals {
                if !db.catArr.contains(i.category) && i.category != "" {
                    db.catArr.append(i.category)
                }
            }
        }
        if !db.allNotifs.isEmpty {
            self.newNotifs = true
        } else {
            self.newNotifs = false
        }
        formatTiles()
    }
}

struct Home_Previews: PreviewProvider {
    static var previews: some View {
        Home()
            .environmentObject(FirestoreManager())
    }
}

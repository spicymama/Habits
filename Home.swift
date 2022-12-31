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
    static var shared = Home()
    static var allNotifs: [Goal] = []
    @State private var addButtonTap = false
    @State var fontSize = UserDefaults.standard.value(forKey: "fontSize") as? Double ?? 15.0
    @State var headerFontSize = UserDefaults.standard.value(forKey: "headerFontSize") as? Double ?? 35.0
    @State var titleFontSize = UserDefaults.standard.value(forKey: "titleFontSize") as? Double ?? 25.0
    @State var backgroundColor = Color(uiColor: UserDefaults.standard.color(forKey: "backgroundColor") ?? .white)
    @State var foregroundColor = Color(uiColor: UserDefaults.standard.color(forKey: "foregroundColor") ?? .gray)
    @State var accentColor = Color(uiColor: UserDefaults.standard.color(forKey: "accentColor") ?? .gray)
    @State var categoryArr: [String] = []
    @State var goToLogin = UserDefaults.standard.bool(forKey: "goToLogin")
    @State var notificationTap = false
    @State var newNotifs = false
    @State var settingsTap = false
    @State var color = Color.gray
    @State var goalTiles: [GoalTile] = []
    @State var doneGoalTiles: [GoalTile] = []
    @State var listTiles: [ListTile] = []
    @State var doneListTiles: [ListTile] = []
    @State var goalTileDrag: GoalTile?
    var padToggle = true
    var pushNavigationBinding : Binding<Bool> {
            .init { () -> Bool in
                appState.navigateTo != nil
            } set: { (newValue) in
                if !newValue { appState.navigateTo = nil }
            }
        }
    var body: some View {
        NavigationStack {
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
                            .foregroundColor(self.accentColor)
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
                            .foregroundColor(self.accentColor)
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
                            .foregroundColor(self.accentColor)
                        }
                        
                        Text("Habits")
                            .frame(maxWidth: 250, maxHeight: 55, alignment: .top)
                            .font(.system(size: self.headerFontSize))
                            .foregroundColor(self.foregroundColor)
                            .padding(.bottom, 25)
                    }
                        ForEach(self.goalTiles) { tile in
                            tile
                                .padding(.top, 20)
                             .onDrag {
                             goalTileDrag = tile
                             return NSItemProvider()
                             }
                             .onDrop(of: [.item], delegate: DropViewDelegate(currentItem: tile, items: $goalTiles, draggingItem: $goalTileDrag, startIndex: goalTiles.firstIndex(of: tile)!))
                        }
                    ForEach(self.listTiles) { tile in
                        tile
                            .padding(.top, 20)
                    }
                    !self.doneGoalTiles.isEmpty || !self.doneListTiles.isEmpty ? Text("History")
                        .frame(maxWidth: 250, maxHeight: 55, alignment: .top)
                        .font(.system(size: self.headerFontSize))
                        .foregroundColor(self.foregroundColor)
                        .padding(.top, 50): nil
                    ForEach(self.doneGoalTiles) { tile in
                        tile
                            .padding(.top, 20)
                            .onDrag {
                                goalTileDrag = tile
                                return NSItemProvider()
                            }
                            .onDrop(of: [.item], delegate: DropViewDelegate(currentItem: tile, items: $doneGoalTiles, draggingItem: $goalTileDrag, isDone: true, startIndex: doneGoalTiles.firstIndex(of: tile)!))
                    }
                    ForEach(self.doneListTiles) { tile in
                        tile
                            .padding(.top, 20)
                    }
                }
            }.frame(maxWidth: .infinity)
            .background(self.backgroundColor)
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
        }.refreshable {
            fetchForRefresh()
        }
        .fullScreenCover(isPresented: pushNavigationBinding) {
            NotificationsView()
        }
    }
    func formatTiles()-> () {
        //UserDefaults.standard.removeObject(forKey: "goalTileOrder")
        //UserDefaults.standard.removeObject(forKey: "doneGoalTileOrder")
        var goalTileArr: [GoalTile] = []
        var listTileArr: [ListTile] = []
        var doneGoalTileArr: [GoalTile] = []
        var doneListTileArr: [ListTile] = []
        self.goalTiles = []
        self.listTiles = []
        self.doneGoalTiles = []
        self.doneListTiles = []
        let goalTileOrder = UserDefaults.standard.value(forKey: "goalTileOrder") as? [String] ?? []
        let doneGoalTileOrder = UserDefaults.standard.value(forKey: "doneGoalTileOrder") as? [String] ?? []
        for goal in User.goalArr {
            if goal.category == "" {
                if goal.endDate < Date.now || goal.prog >= 100.0 {
                    doneGoalTileArr.append(GoalTile(goal: goal))
                    self.doneGoalTiles.append(GoalTile(goal: goal))
                } else {
                    goalTileArr.append(GoalTile(goal: goal))
                    self.goalTiles.append(GoalTile(goal: goal))
                }
            }
        }
        if !goalTileOrder.isEmpty {
            self.goalTiles = []
            for uid in goalTileOrder {
                for tile in goalTileArr {
                    if tile.goal.id == uid {
                        self.goalTiles.append(tile)
                    }
                }
            }
        }
        if !doneGoalTileOrder.isEmpty {
            self.doneGoalTiles = []
            for uid in doneGoalTileOrder {
                for tile in doneGoalTileArr {
                    if tile.goal.id == uid {
                        self.doneGoalTiles.append(tile)
                    }
                }
            }
        }
        for cat in categoryArr {
            var goals: [Goal] = []
            var doneCount = 0
            for goal in User.goalArr {
                if goal.category == cat {
                    goals.append(goal)
                }
                if goal.endDate < Date.now || goal.prog >= 100.0 {
                    doneCount += 1
                }
            }
            let list = ListTile(goalArr: goals)
            if doneCount == goals.count {
                self.doneListTiles.append(list)
            } else {
                self.listTiles.append(list)
            }
        }
    }
    func fetchForRefresh() {
        self.fontSize = UserDefaults.standard.value(forKey: "fontSize") as? Double ?? 15.0
        self.headerFontSize = UserDefaults.standard.value(forKey: "headerFontSize") as? Double ?? 35.0
        self.titleFontSize = UserDefaults.standard.value(forKey: "titleFontSize") as? Double ?? 25.0
        self.backgroundColor = Color(uiColor: UserDefaults.standard.color(forKey: "backgroundColor") ?? .white)
        self.foregroundColor = Color(uiColor: UserDefaults.standard.color(forKey: "foregroundColor") ?? .gray)
        self.accentColor = Color(uiColor: UserDefaults.standard.color(forKey: "accentColor") ?? .gray)
        fetchAllGoals { goals in
            self.categoryArr = []
            User.goalArr = []
            User.goalArr.append(contentsOf: goals)
            for i in goals {
                if !self.categoryArr.contains(i.category) && i.category != "" {
                    self.categoryArr.append(i.category)
                }
            }
        }
        if !Home.allNotifs.isEmpty {
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

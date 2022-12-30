//
//  Home.swift
//  Habits
//
//  Created by Gavin Woffinden on 11/13/22.
//

import SwiftUI
import FirebaseCore
import FirebaseAuth
import FirebaseFirestore

struct Home: View {
    @EnvironmentObject var firestoreManager: FirestoreManager
    @Environment(\.refresh) var refresh
    @ObservedObject var appState = AppState.shared
    @ObservedObject var prefs = DisplayPreferences()
    static var shared = Home()
    static var allNotifs: [Goal] = []
    @State private var addButtonTap = false
    @State var goalArr: [Goal] = []
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
                            .foregroundColor(prefs.accentColor)
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
                            .foregroundColor(prefs.accentColor)
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
                            .foregroundColor(prefs.accentColor)
                        }
                        
                        Text("Habits")
                            .frame(maxWidth: 250, maxHeight: 55, alignment: .top)
                            .font(.system(size: prefs.headerFontSize))
                            .foregroundColor(prefs.foregroundColor)
                            .padding(.bottom, 25)
                    }
                    ForEach(self.goalTiles) { tile in
                        tile
                            .padding(.top, 20)
                    }
                    ForEach(self.listTiles) { tile in
                        tile
                            .padding(.top, 20)
                    }
                    !self.doneGoalTiles.isEmpty || !self.doneListTiles.isEmpty ? Text("History")
                        .frame(maxWidth: 250, maxHeight: 55, alignment: .top)
                        .font(.system(size: prefs.headerFontSize))
                        .foregroundColor(prefs.foregroundColor)
                        .padding(.top, 50): nil
                    ForEach(self.doneGoalTiles) { tile in
                        tile
                            .padding(.top, 20)
                    }
                    ForEach(self.doneListTiles) { tile in
                        tile
                            .padding(.top, 20)
                    }
                }
            }.frame(maxWidth: .infinity)
            .background(prefs.backgroundColor)
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
        self.goalTiles = []
        self.listTiles = []
        self.doneGoalTiles = []
        self.doneListTiles = []
        for goal in goalArr {
            if goal.category == "" {
                if goal.endDate < Date.now || goal.prog >= 100.0 {
                    self.doneGoalTiles.append(GoalTile(goal: goal))
                } else {
                    self.goalTiles.append(GoalTile(goal: goal))
                }
            }
        }
        for cat in categoryArr {
            var goals: [Goal] = []
            var doneCount = 0
            for goal in goalArr {
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
        fetchAllGoals { goals in
            self.categoryArr = []
            self.goalArr = []
            self.goalArr.append(contentsOf: goals)
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

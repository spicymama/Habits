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
    @ObservedObject var appState = AppState.shared
    static var fontSize = UserDefaults.standard.value(forKey: "fontSize") as? Double ?? 15.0
    static var headerFontSize = UserDefaults.standard.value(forKey: "headerFontSize") as? Double ?? 35.0
    static var titleFontSize = UserDefaults.standard.value(forKey: "titleFontSize") as? Double ?? 25.0
    static var backgroundColor = Color(uiColor: UserDefaults.standard.color(forKey: "backgroundColor") ?? .white)
    static var foregroundColor = Color(uiColor: UserDefaults.standard.color(forKey: "foregroundColor") ?? .gray)
    static var accentColor = Color(uiColor: UserDefaults.standard.color(forKey: "accentColor") ?? .orange)
    static var shared = Home()
    static var allNotifs: [Goal] = []
    @State var refresh = true
    @State private var addButtonTap = false
    @State var goalArr: [Goal] = []
    @State var categoryArr: [String] = []
    @State var goToLogin = UserDefaults.standard.bool(forKey: "goToLogin")
    @State var notificationTap = false
    @State var newNotifs = false
    @State var settingsTap = false
    @State var color = Color.gray
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
                            .foregroundColor(Home.foregroundColor)
                            .padding(.trailing)
                            .fullScreenCover(isPresented: $settingsTap) {
                                Settings()
                            }
                            Button {
                                notificationTap = true
                            } label: {
                                Image(systemName: newNotifs ? "bell.badge" : "bell")
                                    .imageScale(.large)
                            }
                            .frame(maxWidth: 15, maxHeight: 15, alignment: .topLeading)
                            .foregroundColor(Home.foregroundColor)
                            .fullScreenCover(isPresented: $notificationTap) {
                                NotificationsView()
                            }
                            Button {
                                EditHabit.editGoal = false
                                addButtonTap = true
                            } label: {
                                Image(systemName: "plus.square")
                                    .imageScale(.large)
                            }.fullScreenCover(isPresented: $addButtonTap) {
                                EditHabit()
                            }
                            .frame(maxWidth: 15, maxHeight: 15, alignment: .topTrailing)
                            .padding(.leading, UIScreen.main.bounds.width - 85)
                            .foregroundColor(Home.foregroundColor)
                        }
                        
                        Text("Habits")
                            .frame(maxWidth: 250, maxHeight: 55, alignment: .top)
                            .font(.system(size: Home.headerFontSize))
                            .foregroundColor(Home.foregroundColor)
                            .padding(.bottom, 25)
                    }
                    ForEach(formatTiles().0) { tile in
                        tile
                            .padding(.top, 30)
                    }
                    ForEach(formatTiles().1) { tile in
                        tile
                            .padding(.top, 30)
                    }
                }
            }.frame(maxWidth: .infinity)
            .background(Home.backgroundColor)
            .onAppear {
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
    func formatTiles()-> ([GoalTile], [ListTile]) {
        var goalTiles: [GoalTile] = []
        var listTiles: [ListTile] = []
        for goal in goalArr {
            if goal.category == "" {
                goalTiles.append(GoalTile(goal: goal))
            }
        }
        for cat in categoryArr {
            var goals: [Goal] = []
            for goal in goalArr {
                if goal.category == cat {
                    goals.append(goal)
                }
            }
            let list = ListTile(goalArr: goals)
            listTiles.append(list)
        }
        return (goalTiles, listTiles)
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
    }
}

struct Home_Previews: PreviewProvider {
    static var previews: some View {
        Home()
            .environmentObject(FirestoreManager())
    }
}

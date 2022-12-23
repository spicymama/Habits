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
    static var shared = Home()
    static var allNotifs: [Goal] = []
    @State var refresh = true
    @State var tap = true
    @State private var addButtonTap = false
    @State var goalArr: [Goal] = []
    @State var categoryArr: [String] = []
    @State var goToLogin = UserDefaults.standard.bool(forKey: "goToLogin")
    @State var navigate = false
    @State var notificationTap = false
    //@State var newNotifications: Bool = Home.allNotifs.count > 0
    var padToggle = true
    var pushNavigationBinding : Binding<Bool> {
            .init { () -> Bool in
                appState.navigateTo != nil
            } set: { (newValue) in
                if !newValue { appState.navigateTo = nil }
            }
        }
    @State var goToNotification = false
    
    var body: some View {
        NavigationStack {
            ScrollView {
                VStack {
                    VStack {
                        HStack {
                            Button {
                               notificationTap = true
                            } label: {
                                Image(systemName: Home.allNotifs.count > 0 ? "bell.badge" : "bell")
                            }
                            .imageScale(.large)
                            .foregroundColor(.gray)
                            .fullScreenCover(isPresented: $notificationTap) {
                                NotificationsView()
                            }
                        Button {
                            EditHabit.editGoal = false
                            addButtonTap = true
                            self.tap = true
                        } label: {
                            Image(systemName: "plus.square")
                                .imageScale(.large)
                        }.fullScreenCover(isPresented: $addButtonTap) {
                            EditHabit()
                        }
                        .frame(maxWidth: 15, maxHeight: 15, alignment: .topTrailing)
                        .padding(.leading, UIScreen.main.bounds.width - 65)
                        .foregroundColor(.gray)
                    }
                        
                        Text("Habits")
                            .frame(maxWidth: 250, maxHeight: 55, alignment: .top)
                            .font(.system(size: 35))
                            .foregroundColor(.gray)
                            .padding(.bottom, 25)
                    }
                        /*
                        Button("Request Permission") {
                            UNUserNotificationCenter.current().requestAuthorization(options: [.alert, .badge, .sound]) { success, error in
                                if success {
                                    print("All set!")
                                } else if let error = error {
                                    print(error.localizedDescription)
                                }
                            }
                        }
                        */

                    ForEach(formatTiles().0) { tile in
                        tile
                            .padding(.top, 30)
                    }
                    ForEach(formatTiles().1) { tile in
                        tile
                            .padding(.top, 30)
                    }
                 
                }
            }.onAppear {
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
                fetchAllGoals() { goals in
                    self.categoryArr = []
                    self.goalArr.append(contentsOf: goals)
                    for i in goals {
                        if !self.categoryArr.contains(i.category) && i.category != "" {
                            self.categoryArr.append(i.category)
                        }
                    }
                }
            }
                self.refresh.toggle()
            }
            .fullScreenCover(isPresented: $goToLogin) {
                LoginView()
            }
        }.refreshable {
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
            self.refresh.toggle()
        }.fullScreenCover(isPresented: $goToNotification) {
          
            NotificationsView()
        }
       
         //   NavigationLink(destination: NotificationsView(), isActive: $goToNotification) { EmptyView() }
        
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
}

struct Home_Previews: PreviewProvider {
    static var previews: some View {
        Home()
            .environmentObject(FirestoreManager())
    }
}


//
//  Home.swift
//  Habits
//
//  Created by Gavin Woffinden on 11/13/22.
//

import SwiftUI
import UserNotifications

struct Home: View {
    @EnvironmentObject var firestoreManager: FirestoreManager
    static var shared = Home()
    @State var refresh = true
    @State var tap = true
    @State private var addButtonTap = false
    @State var goalArr: [Goal] = []
    @State var categoryArr: [String] = []
    @State var singleGoal: Goal = Goal.placeholderGoal
    @State var goToLogin = true
    var padToggle = true
    
    var body: some View {
        NavigationStack {
            ScrollView {
                VStack {
                    VStack {
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
                        
                        Text("Habits")
                            .frame(maxWidth: 250, maxHeight: 55, alignment: .top)
                            .font(.system(size: 35))
                            .foregroundColor(.gray)
                            .padding(.bottom, 25)
                    }
                    VStack {
                        Button("Request Permission") {
                            UNUserNotificationCenter.current().requestAuthorization(options: [.alert, .badge, .sound]) { success, error in
                                if success {
                                    print("All set!")
                                } else if let error = error {
                                    print(error.localizedDescription)
                                }
                            }                        }

                        Button("Schedule Notification") {
                            let content = UNMutableNotificationContent()
                            content.title = "Feed the cat"
                            content.subtitle = "It looks hungry"
                            content.sound = UNNotificationSound.default

                            // show this notification five seconds from now
                            let trigger = UNTimeIntervalNotificationTrigger(timeInterval: 5, repeats: false)

                            // choose a random identifier
                            let request = UNNotificationRequest(identifier: UUID().uuidString, content: content, trigger: trigger)

                            // add our notification request
                            UNUserNotificationCenter.current().add(request)                        }
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
            }.onAppear {
                if self.goToLogin == false {
                fetchAllGoals() { goals in
                    self.categoryArr = []
                    self.goalArr.append(contentsOf: goals)
                    self.singleGoal = goals[0]
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
                self.singleGoal = goals[0]
                for i in goals {
                    if !self.categoryArr.contains(i.category) && i.category != "" {
                        self.categoryArr.append(i.category)
                    }
                }
            }
            self.refresh.toggle()
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
}

struct Home_Previews: PreviewProvider {
    static var previews: some View {
        Home()
            .environmentObject(FirestoreManager())
    }
}


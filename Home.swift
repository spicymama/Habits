//
//  Home.swift
//  Habits
//
//  Created by Gavin Woffinden on 11/13/22.
//

import SwiftUI

struct Home: View {
    @EnvironmentObject var firestoreManager: FirestoreManager
    static var shared = Home()
    @State var refresh = true
    @State var tap = ListTile.shared.wasTapped
    @State private var addButtonTap = false
    @State var goalArr: [Goal] = []
    @State var categoryArr: [String] = []
    @State var singleGoal: Goal = Goal()
    let categories = [("Habits to Get"), ("Habits to Quit"), ("Habits")]
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
                    GoalTile(goal: User.goalArr.first!)
                 
                ListTile(goalArr: self.goalArr)
                        .padding(.top, 30)
                ListTile(goalArr: self.goalArr)
                            .padding(.top, 30)
                 
                }
            }.onAppear {
                fetchAllGoals() { goal in
                    self.goalArr.append(contentsOf: goal)
                }
            }
        }.refreshable {
            fetchAllGoals { goal in
                self.goalArr = []
                self.goalArr.append(contentsOf: goal)
                
            }
        }
    }
}

struct Home_Previews: PreviewProvider {
    static var previews: some View {
        Home()
            .environmentObject(FirestoreManager())
    }
}


//
//  FirebaseFunctions.swift
//  Habits
//
//  Created by Gavin Woffinden on 12/6/22.
//

import Foundation
import Firebase
import SwiftUI

class FirestoreManager: ObservableObject {
    @Published var goal: Goal = Goal(id: "", category: "", title: "", dateCreated: Date.now, endDate: Date.distantFuture, goodCheckins: 0, badCheckins: 0, monNotifs: [], tusNotifs: [], wedNotifs: [], thursNotifs: [], friNotifs: [], satNotifs: [], sunNotifs: [], scheduledNotifs: [Date()], progressTracker: "", selfNotes: "", prog: 0.0)
}
func createGoal(goal: Goal) {
    guard let currentUser = UserDefaults.standard.value(forKey: "userID") as? String else { return }
    let db = Firestore.firestore()
    let docRef = db.collection("User").document(currentUser).collection("Goals").document(goal.id)
   // let id = docRef.documentID
    let goalData: [String : Any] = [
        "id" : goal.id,
        "badCheckins" : goal.badCheckins,
        "category" : goal.category,
        "monNotifs" : goal.monNotifs,
        "tusNotifs" : goal.tusNotifs,
        "wedNotifs" : goal.wedNotifs,
        "thursNotifs" : goal.thursNotifs,
        "friNotifs" : goal.friNotifs,
        "satNotifs" : goal.satNotifs,
        "sunNotifs" : goal.sunNotifs,
        "dateCreated" : Date.now,
        "endDate" : goal.endDate,
        "goodCheckins" : goal.goodCheckins,
        "prog" : goal.prog,
        "progressTracker" : goal.progressTracker,
        "scheduledNotifs" : goal.scheduledNotifs,
        "selfNotes" : goal.selfNotes,
        "title" : goal.title
    ]
    
    docRef.setData(goalData) { error in
        if let error = error {
            print("Error writing document: \(error)")
        } else {
           // Home.shared.goalArr.append(goal)
            print("Document successfully written!")
        }
    }
}

func createUser(user: User) {
    let db = Firestore.firestore()
    let docRef = db.collection("User").document(user.id)
    let id = docRef.documentID
    let userData: [String : Any] = [
        "id" : id,
        "email" : user.email,
        "password" : user.password
        ]
    docRef.setData(userData) { error in
        if let error = error {
            print("Error creating user: \(error)")
        } else {
            print("User created successfully")
            let defaults = UserDefaults.standard
            defaults.set(id, forKey: "userID")
            defaults.set(user.email, forKey: "userEmail")
        }
    }
}

func updateGoal(goal: Goal) {
    guard let currentUser = UserDefaults.standard.value(forKey: "userID") as? String else { return }
    let db = Firestore.firestore()
    let docRef = db.collection("User").document(currentUser).collection("Goals").document(goal.id)
    let goalData: [String : Any] = [
        "id" : goal.id,
        "badCheckins" : goal.badCheckins,
        "category" : goal.category,
        "monNotifs" : goal.monNotifs,
        "tusNotifs" : goal.tusNotifs,
        "wedNotifs" : goal.wedNotifs,
        "thursNotifs" : goal.thursNotifs,
        "friNotifs" : goal.friNotifs,
        "satNotifs" : goal.satNotifs,
        "sunNotifs" : goal.sunNotifs,
        "dateCreated" : goal.dateCreated,
        "endDate" : goal.endDate,
        "goodCheckins" : goal.goodCheckins,
        "prog" : goal.prog,
        "progressTracker" : goal.progressTracker,
        "scheduledNotifs" : goal.scheduledNotifs,
        "selfNotes" : goal.selfNotes,
        "title" : goal.title,
    ]
    docRef.setData(goalData, merge: true) { error in
        if let error = error {
            print("Error writing document: \(error)")
        } else {
            Home.shared.goalArr = Home.shared.goalArr.map { $0.id == goal.id ? goal : $0 }
            print("Document successfully updated!")
        }
    }
}

func fetchSingleGoal(id: String, completion: @escaping (Goal) -> Void) {
    guard let currentUser = UserDefaults.standard.value(forKey: "userID") as? String else { return }
    var goal: Goal = Goal(id: id, category: "", title: "", dateCreated: Date.now, endDate: Date.distantFuture, goodCheckins: 0, badCheckins: 0,  monNotifs: [], tusNotifs: [], wedNotifs: [], thursNotifs: [], friNotifs: [], satNotifs: [], sunNotifs: [], scheduledNotifs: [], progressTracker: "", selfNotes: "", prog: 0.0)
    let db = Firestore.firestore()
    print(id)
    DispatchQueue.main.async {
        db.collection("User").document(currentUser).collection("Goals").document(id).getDocument() { (querySnapshot, error) in
            if let error = error {
                print("Error getting documents: \(error)")
            } else {
                guard let querySnapshot = querySnapshot else { return }
                    guard let dateCreated = querySnapshot.data()!["dateCreated"] as? Timestamp else { return }
                   // let endDate = querySnapshot.data()!["endDate"] as? Timestamp ?? Timestamp(date: Date.distantFuture)
                    goal.title = querySnapshot.get("title") as! String
                    goal.dateCreated = dateCreated.dateValue()
                  //  goal.category = querySnapshot.get("category") as! String
                    goal.progressTracker = querySnapshot.get("progressTracker") as! String
                    goal.prog = querySnapshot.get("prog") as! Double
                    goal.goodCheckins = querySnapshot.get("goodCheckins") as! Int
                    goal.badCheckins = querySnapshot.get("badCheckins") as! Int
                   // goal.endDate = endDate.dateValue()
            }
            completion(goal)
        }
    }
    func timestampToDate(dates: [Timestamp])-> [Date] {
        var finalArr: [Date] = []
        for i in dates {
            finalArr.append(i.dateValue())
        }
        return finalArr
    }
}

func fetchAllGoals(completion: @escaping ([Goal]) -> Void) {
    guard let currentUser = UserDefaults.standard.value(forKey: "userID") as? String else { return }
    var allGoals: [Goal] = []
    var goal: Goal = Goal(id: "", category: "", title: "", dateCreated: Date.now, endDate: Date.distantFuture, goodCheckins: 0, badCheckins: 0,  monNotifs: [], tusNotifs: [], wedNotifs: [], thursNotifs: [], friNotifs: [], satNotifs: [], sunNotifs: [], scheduledNotifs: [], progressTracker: "", selfNotes: "", prog: 0.0)
    let db = Firestore.firestore()
    DispatchQueue.main.async {
        db.collection("User").document(currentUser).collection("Goals").getDocuments() { (querySnapshot, error) in
            if let error = error {
                print("Error getting documents: \(error)")
            } else {
                for document in querySnapshot!.documents {
                    guard let notifs = document.data()["scheduledNotifs"] as? [Timestamp] else  { return }
                    let monNotifs = document.data()["monNotifs"] as? [Timestamp] ?? []
                    let tusNotifs = document.data()["tusNotifs"] as? [Timestamp] ?? []
                    let wedNotifs = document.data()["wedNotifs"] as? [Timestamp] ?? []
                    let thursNotifs = document.data()["thursNotifs"] as? [Timestamp] ?? []
                    let friNotifs = document.data()["friNotifs"] as? [Timestamp] ?? []
                    let satNotifs = document.data()["satNotifs"] as? [Timestamp] ?? []
                    let sunNotifs = document.data()["sunNotifs"] as? [Timestamp] ?? []
                    guard let dateCreated = document.data()["dateCreated"] as? Timestamp else { return }
                    guard let endDate = document.data()["endDate"] as? Timestamp else { return }
                    goal.id = document.get("id") as! String
                    goal.title = document.get("title") as! String
                    goal.dateCreated = dateCreated.dateValue()
                    goal.category = document.get("category") as! String
                    goal.selfNotes = document.get("selfNotes") as! String
                    goal.scheduledNotifs = timestampToDate(dates: notifs)
                    goal.monNotifs = timestampToDate(dates: monNotifs)
                    goal.tusNotifs = timestampToDate(dates: tusNotifs)
                    goal.wedNotifs = timestampToDate(dates: wedNotifs)
                    goal.thursNotifs = timestampToDate(dates: thursNotifs)
                    goal.friNotifs = timestampToDate(dates: friNotifs)
                    goal.satNotifs = timestampToDate(dates: satNotifs)
                    goal.sunNotifs = timestampToDate(dates: sunNotifs)
                    goal.progressTracker = document.get("progressTracker") as! String
                    goal.prog = document.get("prog") as! Double
                    goal.goodCheckins = document.get("goodCheckins") as! Int
                    goal.badCheckins = document.get("badCheckins") as! Int
                    goal.endDate = endDate.dateValue()
                    allGoals.append(goal)
                    goal = Goal(id: "", category: "", title: "", dateCreated: Date.now, endDate: Date.distantFuture, goodCheckins: 0, badCheckins: 0,  monNotifs: [], tusNotifs: [], wedNotifs: [], thursNotifs: [], friNotifs: [], satNotifs: [], sunNotifs: [], scheduledNotifs: [Date()], progressTracker: "", selfNotes: "", prog: 0.0)
                }
                completion(allGoals)
            }
        }
        
    }
    func timestampToDate(dates: [Timestamp])-> [Date] {
        var finalArr: [Date] = []
        for i in dates {
            finalArr.append(i.dateValue())
        }
        return finalArr
    }
}

func deleteGoal(goal: Goal) {
    guard let currentUser = UserDefaults.standard.value(forKey: "userID") as? String else { return }
    let db = Firestore.firestore()
    let docRef = db.collection("User").document(currentUser).collection("Goals").document(goal.id)
    docRef.delete() { err in
        if let err = err {
          print("Error removing document: \(err)")
        }
        else {
            for i in Home.shared.goalArr {
                var index = 0
                if i.id == goal.id {
                    Home.shared.goalArr.remove(at: index)
                }
                index += 1
            }
            print(Home.shared.goalArr)
          print("Document successfully removed!")
        }
      }
}

/*
 let keys = document.data().map{$0.key}
 let values = document.data().map {$0.value}
 for index in keys.indices {
     if keys[index] == "title" {
         goal.title = values[index] as! String
         goal.title = document.get("title") as! String
     }
     if keys[index] == "badCheckins" {
         goal.badCheckins = values[index] as! Int
     }
     if keys[index] == "category" {
         goal.category = values[index] as! String
     }
     if keys[index] == "dailyNotifs" {
        
         let d = values[index]
        // goal.notificationTimes = date
     }
     if keys[index] == "dateCreated" {
         goal.dateCreated = values[index] as! Date
     }
     if keys[index] == "endDate" {
         goal.endDate = values[index] as! Date
     }
     if keys[index] == "goodCheckins" {
         goal.goodCheckins = values[index] as! Int
     }
     if keys[index] == "prog" {
         goal.prog = values[index] as! Double
     }
     if keys[index] == "progressTracker" {
         goal.progressTracker = values[index] as! String
     }
     if keys[index] == "scheduledNotifs" {
         goal.notificationTimes = values[index] as! [Date]
         
     }
     if keys[index] == "selfNotes" {
         goal.selfNotes = values[index] as! String
     }
 */

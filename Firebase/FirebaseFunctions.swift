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
    @Published var goal: Goal = Goal(id: "", listID: "", category: "", title: "", dateCreated: Date.now, endDate: Date.distantFuture, goodCheckins: 0, badCheckins: 0, monNotifs: [], tusNotifs: [], wedNotifs: [], thursNotifs: [], friNotifs: [], satNotifs: [], sunNotifs: [], scheduledNotifs: [Date()], progressTracker: "", selfNotes: "", prog: 0.0)
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
    var goal: Goal = Goal(id: id, listID: "", category: "", title: "", dateCreated: Date.now, endDate: Date.distantFuture, goodCheckins: 0, badCheckins: 0,  monNotifs: [], tusNotifs: [], wedNotifs: [], thursNotifs: [], friNotifs: [], satNotifs: [], sunNotifs: [], scheduledNotifs: [], progressTracker: "", selfNotes: "", prog: 0.0)
    let db = Firestore.firestore()
    print(id)
    DispatchQueue.main.async {
        db.collection("User").document(currentUser).collection("Goals").document(id).getDocument() { (querySnapshot, error) in
            if let error = error {
                print("Error getting documents: \(error)")
            } else {
                guard let querySnapshot = querySnapshot else { return }
                guard let notifs = querySnapshot.data()!["scheduledNotifs"] as? [Timestamp] else  { return }
                let monNotifs = querySnapshot.data()!["monNotifs"] as? [Timestamp] ?? []
                let tusNotifs = querySnapshot.data()!["tusNotifs"] as? [Timestamp] ?? []
                let wedNotifs = querySnapshot.data()!["wedNotifs"] as? [Timestamp] ?? []
                let thursNotifs = querySnapshot.data()!["thursNotifs"] as? [Timestamp] ?? []
                let friNotifs = querySnapshot.data()!["friNotifs"] as? [Timestamp] ?? []
                let satNotifs = querySnapshot.data()!["satNotifs"] as? [Timestamp] ?? []
                let sunNotifs = querySnapshot.data()!["sunNotifs"] as? [Timestamp] ?? []
                guard let dateCreated = querySnapshot.data()!["dateCreated"] as? Timestamp else { return }
                guard let endDate = querySnapshot.data()!["endDate"] as? Timestamp else { return }
                goal.id = querySnapshot.get("id") as! String
                goal.title = querySnapshot.get("title") as! String
                goal.dateCreated = dateCreated.dateValue()
                goal.category = querySnapshot.get("category") as! String
                goal.selfNotes = querySnapshot.get("selfNotes") as! String
                goal.scheduledNotifs = timestampToDate(dates: notifs)
                goal.monNotifs = timestampToDate(dates: monNotifs)
                goal.tusNotifs = timestampToDate(dates: tusNotifs)
                goal.wedNotifs = timestampToDate(dates: wedNotifs)
                goal.thursNotifs = timestampToDate(dates: thursNotifs)
                goal.friNotifs = timestampToDate(dates: friNotifs)
                goal.satNotifs = timestampToDate(dates: satNotifs)
                goal.sunNotifs = timestampToDate(dates: sunNotifs)
                goal.progressTracker = querySnapshot.get("progressTracker") as! String
                goal.prog = querySnapshot.get("prog") as! Double
                goal.goodCheckins = querySnapshot.get("goodCheckins") as! Int
                goal.badCheckins = querySnapshot.get("badCheckins") as! Int
                goal.endDate = endDate.dateValue()
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
    var goal: Goal = Goal(id: "", listID: "", category: "", title: "", dateCreated: Date.now, endDate: Date.distantFuture, goodCheckins: 0, badCheckins: 0,  monNotifs: [], tusNotifs: [], wedNotifs: [], thursNotifs: [], friNotifs: [], satNotifs: [], sunNotifs: [], scheduledNotifs: [], progressTracker: "", selfNotes: "", prog: 0.0)
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
                    goal = Goal(id: "", listID: "", category: "", title: "", dateCreated: Date.now, endDate: Date.distantFuture, goodCheckins: 0, badCheckins: 0,  monNotifs: [], tusNotifs: [], wedNotifs: [], thursNotifs: [], friNotifs: [], satNotifs: [], sunNotifs: [], scheduledNotifs: [Date()], progressTracker: "", selfNotes: "", prog: 0.0)
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
    let notifsArr = UNUserNotificationCenter.current()
    notifsArr.getDeliveredNotifications { notifs in
        for notif in notifs {
            let notifID = notif.request.identifier
            let goalID = notif.request.content.userInfo["goalUID"]
            if goalID as! String == goal.id {
                UNUserNotificationCenter.current().removeDeliveredNotifications(withIdentifiers: [notifID])
            }
        }
    }
    notifsArr.getPendingNotificationRequests { requests in
        for request in requests {
            let goalID = request.content.userInfo["goalUID"]
            if goalID as! String == goal.id {
                UNUserNotificationCenter.current().removePendingNotificationRequests(withIdentifiers: [request.identifier])
            }
        }
    }
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

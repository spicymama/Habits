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
    @Published var goal: Goal = Goal()
}

func createGoal(goal: Goal) {
    let goalData: [String : Any] = [
       // "id" : goal.id,
        "badCheckins" : goal.badCheckins,
        "category" : goal.category,
       // "dailyNotifs" : goal.notificationTimes,
        "dateCreated" : goal.dateCreated,
        "endDate" : goal.endDate,
        "goodCheckins" : goal.goodCheckins,
        "prog" : goal.prog,
        "progressTracker" : goal.progressTracker,
        "scheduledNotifs" : goal.notificationTimes,
        "selfNotes" : goal.selfNotes,
        "title" : goal.title
    ]
    let db = Firestore.firestore()
    let docRef = db.collection("Goals").document(goal.title)
    
    docRef.setData(goalData) { error in
        if let error = error {
            print("Error writing document: \(error)")
        } else {
            print("Document successfully written!")
        }
    }
}

func updateGoal(goal: Goal) {
    let goalData: [String : Any] = [
      //  "id" : goal.id,
        "badCheckins" : goal.badCheckins,
        "category" : goal.category,
       // "dailyNotifs" : goal.notificationTimes,
        "dateCreated" : goal.dateCreated,
        "endDate" : goal.endDate,
        "goodCheckins" : goal.goodCheckins,
        "prog" : goal.prog,
        "progressTracker" : goal.progressTracker,
        "scheduledNotifs" : goal.notificationTimes,
        "selfNotes" : goal.selfNotes,
        "title" : goal.title
    ]
    let db = Firestore.firestore()
    let docRef = db.collection("Goals").document(goal.title)
    
    docRef.setData(goalData, merge: true) { error in
        if let error = error {
            print("Error writing document: \(error)")
        } else {
            print("Document successfully updated!")
        }
    }
}

func fetchAllGoals() {
    var goal: Goal = Goal()
    let db = Firestore.firestore()

        db.collection("Goals").getDocuments() { (querySnapshot, error) in
                        if let error = error {
                                print("Error getting documents: \(error)")
                        } else {
                                for document in querySnapshot!.documents {
                                        print("\(document.documentID): \(document.data())")
                                    guard let notifs = document.data()["scheduledNotifs"] as? [Timestamp] else  { return }
                                    guard let dateCreated = document.data()["dateCreated"] as? Timestamp else { return }
                                    guard let endDate = document.data()["endDate"] as? Timestamp else { return }
                                    goal.title = document.get("title") as! String
                                    goal.dateCreated = dateCreated.dateValue()
                                    goal.category = document.get("category") as! String
                                    goal.selfNotes = document.get("selfNotes") as! String
                                    goal.notificationTimes = timestampToDate(dates: notifs)
                                    goal.progressTracker = document.get("progressTracker") as! String
                                    goal.prog = document.get("prog") as! Double
                                    goal.goodCheckins = document.get("goodCheckins") as! Int
                                    goal.badCheckins = document.get("badCheckins") as! Int
                                    goal.endDate = endDate.dateValue()
                                  
                                    User.goalArr.insert(goal, at: 0)
                                    goal = Goal()
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

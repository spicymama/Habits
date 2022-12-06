//
//  FirebaseFunctions.swift
//  Habits
//
//  Created by Gavin Woffinden on 12/6/22.
//

import Foundation
import Firebase

class FirestoreManager: ObservableObject {

}

func createGoal(goal: Goal) {
    let goalData: [String : Any] = [
       // "id" : goal.id,
        "badCheckins" : goal.badCheckins,
        "category" : goal.category,
        "dailyNotifs" : goal.notificationTimes,
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
        "dailyNotifs" : goal.notificationTimes,
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

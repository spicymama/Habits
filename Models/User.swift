//
//  User.swift
//  Habits
//
//  Created by Gavin Woffinden on 11/14/22.
//

import Foundation


class User {
    let name: String
    let email: String
    let password: String
    let username: String
    
    init(name: String, email: String, password: String, username: String) {
        self.name = name
        self.email = email
        self.password = password
        self.username = username
    }
    static let goalArr = [Goal(category: "Habits to Get", title: "Sdand up straight", dateCreated: Date.now, endDate: Date.now + 3, goodCheckins: 3, badCheckins: 2, notificationTimes: [Date.now], selfNotes: "This is not that easy", prog: 15.0), Goal(category: "Habits to Get", title: "Workout 3 times a week", dateCreated: Date.now, endDate: Date.now + 50, goodCheckins: 9, badCheckins: 3, notificationTimes: [Date.now], selfNotes: "Gonna get so big and strong", prog: 26.0)]/*, Goal(category: "Habits to Get", title: "Brush Teeth Twice a Day", dateCreated: Date.now, endDate: Date.now + 3, goodCheckins: 3, badCheckins: 2, notificationTimes: [Date.now], selfNotes: "This is not that easy", prog: 39.0), Goal(category: "Habits to Get", title: "Eat More Vegetables", dateCreated: Date.now, endDate: Date.now + 50, goodCheckins: 9, badCheckins: 3, notificationTimes: [Date.now], selfNotes: "Gonna get so big and strong", prog: 100.0), Goal(category: "Habits to Get", title: "Sdand up straight", dateCreated: Date.now, endDate: Date.now + 3, goodCheckins: 3, badCheckins: 2, notificationTimes: [Date.now], selfNotes: "This is not that easy", prog: 15.0), Goal(category: "Habits to Get", title: "Workout 3 times a week", dateCreated: Date.now, endDate: Date.now + 50, goodCheckins: 9, badCheckins: 3, notificationTimes: [Date.now], selfNotes: "Gonna get so big and strong", prog: 26.0), Goal(category: "Habits to Get", title: "Brush Teeth Twice a Day", dateCreated: Date.now, endDate: Date.now + 3, goodCheckins: 3, badCheckins: 2, notificationTimes: [Date.now], selfNotes: "This is not that easy", prog: 39.0), Goal(category: "Habits to Get", title: "Eat More Vegetables", dateCreated: Date.now, endDate: Date.now + 50, goodCheckins: 9, badCheckins: 3, notificationTimes: [Date.now], selfNotes: "Gonna get so big and strong", prog: 100.0), Goal(category: "Habits to Get", title: "Sdand up straight", dateCreated: Date.now, endDate: Date.now + 3, goodCheckins: 3, badCheckins: 2, notificationTimes: [Date.now], selfNotes: "This is not that easy", prog: 15.0), Goal(category: "Habits to Get", title: "Workout 3 times a week", dateCreated: Date.now, endDate: Date.now + 50, goodCheckins: 9, badCheckins: 3, notificationTimes: [Date.now], selfNotes: "Gonna get so big and strong", prog: 26.0), Goal(category: "Habits to Get", title: "Brush Teeth Twice a Day", dateCreated: Date.now, endDate: Date.now + 3, goodCheckins: 3, badCheckins: 2, notificationTimes: [Date.now], selfNotes: "This is not that easy", prog: 39.0), Goal(category: "Habits to Get", title: "Eat More Vegetables", dateCreated: Date.now, endDate: Date.now + 50, goodCheckins: 9, badCheckins: 3, notificationTimes: [Date.now], selfNotes: "Gonna get so big and strong", prog: 100.0)]*/
    
}

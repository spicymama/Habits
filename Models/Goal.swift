//
//  Goal.swift
//  Habits
//
//  Created by Gavin Woffinden on 11/14/22.
//

import Foundation
import SwiftUI
class Goal : Identifiable {
    var category: String
    var title: String
    var dateCreated: Date
    var endDate: Date
    var goodCheckins: Int = 0
    var badCheckins: Int = 0
    var notificationTimes: [Date]
    var selfNotes: String
    var prog: Double
    @State var progress = 0.0
    init(category: String, title: String, dateCreated: Date, endDate: Date, goodCheckins: Int, badCheckins: Int, notificationTimes: [Date], selfNotes: String, prog: Double) {
        self.category = category
        self.title = title
        self.dateCreated = dateCreated
        self.endDate = endDate
        self.goodCheckins = goodCheckins
        self.badCheckins = badCheckins
        self.notificationTimes = notificationTimes
        self.selfNotes = selfNotes
        self.prog = prog
    }
    
    static let goalArr = [Goal(category: "Habits to Get", title: "Sdand up straight", dateCreated: Date.now, endDate: Date.now + 3, goodCheckins: 3, badCheckins: 2, notificationTimes: [Date.now], selfNotes: "This is not that easy", prog: 15.0), Goal(category: "Habits to Get", title: "Workout 3 times a week", dateCreated: Date.now, endDate: Date.now + 50, goodCheckins: 9, badCheckins: 3, notificationTimes: [Date.now], selfNotes: "Gonna get so big and strong", prog: 26.0), Goal(category: "Habits to Get", title: "Sdand up straight", dateCreated: Date.now, endDate: Date.now + 3, goodCheckins: 3, badCheckins: 2, notificationTimes: [Date.now], selfNotes: "This is not that easy", prog: 39.0), Goal(category: "Habits to Get", title: "Workout 3 times a week", dateCreated: Date.now, endDate: Date.now + 50, goodCheckins: 9, badCheckins: 3, notificationTimes: [Date.now], selfNotes: "Gonna get so big and strong", prog: 100.0)/*, Goal(category: "Habits to Get", title: "Sdand up straight", dateCreated: Date.now, endDate: Date.now + 3, goodCheckins: 3, badCheckins: 2, notificationTimes: [Date.now], selfNotes: "This is not that easy"), Goal(category: "Habits to Get", title: "Workout 3 times a week", dateCreated: Date.now, endDate: Date.now + 50, goodCheckins: 9, badCheckins: 3, notificationTimes: [Date.now], selfNotes: "Gonna get so big and strong"), Goal(category: "Habits to Get", title: "Sdand up straight", dateCreated: Date.now, endDate: Date.now + 3, goodCheckins: 3, badCheckins: 2, notificationTimes: [Date.now], selfNotes: "This is not that easy"), Goal(category: "Habits to Get", title: "Workout 3 times a week", dateCreated: Date.now, endDate: Date.now + 50, goodCheckins: 9, badCheckins: 3, notificationTimes: [Date.now], selfNotes: "Gonna get so big and strong"), Goal(category: "Habits to Get", title: "Sdand up straight", dateCreated: Date.now, endDate: Date.now + 3, goodCheckins: 3, badCheckins: 2, notificationTimes: [Date.now], selfNotes: "This is not that easy"), Goal(category: "Habits to Get", title: "Workout 3 times a week", dateCreated: Date.now, endDate: Date.now + 50, goodCheckins: 9, badCheckins: 3, notificationTimes: [Date.now], selfNotes: "Gonna get so big and strong"), Goal(category: "Habits to Get", title: "Sdand up straight", dateCreated: Date.now, endDate: Date.now + 3, goodCheckins: 3, badCheckins: 2, notificationTimes: [Date.now], selfNotes: "This is not that easy"), Goal(category: "Habits to Get", title: "Workout 3 times a week", dateCreated: Date.now, endDate: Date.now + 50, goodCheckins: 9, badCheckins: 3, notificationTimes: [Date.now], selfNotes: "Gonna get so big and strong"), Goal(category: "Habits to Get", title: "Sdand up straight", dateCreated: Date.now, endDate: Date.now + 3, goodCheckins: 3, badCheckins: 2, notificationTimes: [Date.now], selfNotes: "This is not that easy"), Goal(category: "Habits to Get", title: "Workout 3 times a week", dateCreated: Date.now, endDate: Date.now + 50, goodCheckins: 9, badCheckins: 3, notificationTimes: [Date.now], selfNotes: "Gonna get so big and strong"), Goal(category: "Habits to Get", title: "Sdand up straight", dateCreated: Date.now, endDate: Date.now + 3, goodCheckins: 3, badCheckins: 2, notificationTimes: [Date.now], selfNotes: "This is not that easy"), Goal(category: "Habits to Get", title: "Workout 3 times a week", dateCreated: Date.now, endDate: Date.now + 50, goodCheckins: 9, badCheckins: 3, notificationTimes: [Date.now], selfNotes: "Gonna get so big and strong"), Goal(category: "Habits to Get", title: "Sdand up straight", dateCreated: Date.now, endDate: Date.now + 3, goodCheckins: 3, badCheckins: 2, notificationTimes: [Date.now], selfNotes: "This is not that easy"), Goal(category: "Habits to Get", title: "Workout 3 times a week", dateCreated: Date.now, endDate: Date.now + 50, goodCheckins: 9, badCheckins: 3, notificationTimes: [Date.now], selfNotes: "Gonna get so big and strong")*/]
}

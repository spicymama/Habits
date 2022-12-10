//
//  Goal.swift
//  Habits
//
//  Created by Gavin Woffinden on 11/14/22.
//

import Foundation
import SwiftUI

class Goal: Identifiable, ObservableObject {
    
    var id: String = ""
    var category: String = ""
    var title: String = ""
    var dateCreated: Date = Date.now
    var endDate: Date = Date.distantFuture
    var goodCheckins: Int = 0
    var badCheckins: Int = 0
    var dailyNotifs: [Date] = [Date.now]
    var scheduledNotifs: [Date] = [Date.now]
    var progressTracker: String = ""
    var selfNotes: String = ""
    var prog: Double = 0.0

    init(id: String, category: String, title: String, dateCreated: Date, endDate: Date, goodCheckins: Int, badCheckins: Int, dailyNotifs: [Date], scheduledNotifs: [Date], progressTracker: String, selfNotes: String, prog: Double) {
        self.id = id
        self.category = category
        self.title = title
        self.dateCreated = dateCreated
        self.endDate = endDate
        self.goodCheckins = goodCheckins
        self.badCheckins = badCheckins
        self.dailyNotifs = dailyNotifs
        self.scheduledNotifs = scheduledNotifs
        self.progressTracker = progressTracker
        self.selfNotes = selfNotes
        self.prog = prog
    }
    
    static var placeholderGoal = Goal(id: "", category: "Category", title: "Title", dateCreated: Date.now, endDate: Date.distantFuture, goodCheckins: 0, badCheckins: 0, dailyNotifs: [Date()], scheduledNotifs: [Date()], progressTracker: "Manually track my progress", selfNotes: "Here are some notes", prog: 50.0)
}

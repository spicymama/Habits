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
    var listID: String = ""
    var category: String = ""
    var title: String = ""
    var dateCreated: Date = Date()
    var endDate: Date = Date()
    var goodCheckins: Int = 0
    var badCheckins: Int = 0
    var monNotifs: [Date] = []
    var tusNotifs: [Date] = []
    var wedNotifs: [Date] = []
    var thursNotifs: [Date] = []
    var friNotifs: [Date] = []
    var satNotifs: [Date] = []
    var sunNotifs: [Date] = []
    var scheduledNotifs: [Date] = []
    var progressTracker: String = ""
    var selfNotes: String = ""
    var prog: Double = 0.0

    init(id: String, listID: String, category: String, title: String, dateCreated: Date, endDate: Date, goodCheckins: Int, badCheckins: Int, monNotifs: [Date], tusNotifs: [Date], wedNotifs: [Date], thursNotifs: [Date], friNotifs: [Date], satNotifs: [Date], sunNotifs: [Date], scheduledNotifs: [Date], progressTracker: String, selfNotes: String, prog: Double) {
        self.id = id
        self.listID = listID
        self.category = category
        self.title = title
        self.dateCreated = dateCreated
        self.endDate = endDate
        self.goodCheckins = goodCheckins
        self.badCheckins = badCheckins
        self.monNotifs = monNotifs
        self.tusNotifs = tusNotifs
        self.wedNotifs = wedNotifs
        self.thursNotifs = thursNotifs
        self.friNotifs = friNotifs
        self.satNotifs = satNotifs
        self.sunNotifs = sunNotifs
        self.scheduledNotifs = scheduledNotifs
        self.progressTracker = progressTracker
        self.selfNotes = selfNotes
        self.prog = prog
    }
    
    static var placeholderGoal = Goal(id: "", listID: "", category: "Category", title: "Title", dateCreated: Date.now, endDate: Date.distantFuture, goodCheckins: 0, badCheckins: 0, monNotifs: [], tusNotifs: [Date.now], wedNotifs: [Date()], thursNotifs: [], friNotifs: [Date.now], satNotifs: [], sunNotifs: [], scheduledNotifs: [], progressTracker: "Manually track my progress", selfNotes: "Here are some notes", prog: 50.0)
}

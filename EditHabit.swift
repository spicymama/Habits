//
//  EditHabit.swift
//  Habits
//
//  Created by Gavin Woffinden on 11/29/22.
//

import SwiftUI

struct EditHabit: View {
    static var shared = EditHabit()
    @Environment(\.dismiss) var dismiss
    var id: String = UUID().uuidString
    var prog: Double = 0
    var dateCreated: Date = Date()
    @State var title = ""
    @State var endDateTap = true
    @State var lilEndDateTap = true
    @State var remindersTap = true
    @State var dailyReminderTap = true
    @State var scheduledReminderTap = true
    @State var progressTrackerTap = true
    @State var notesTap = true
    @State var selectedTracker = ""
    @State var monDate = Date.now
    @State var tusDate = Date.now
    @State var wedDate = Date.now
    @State var thursDate = Date.now
    @State var friDate = Date.now
    @State var satDate = Date.now
    @State var sunDate = Date.now
    @State var endDate = Date.now
    @State var scheduledDate = Date.now
    @State var monHidden = true
    @State var tusHidden = true
    @State var wedHidden = true
    @State var thursHidden = true
    @State var friHidden = true
    @State var satHidden = true
    @State var sunHidden = true
    @State var endDateHidden = true
    @State var monNotifs: [Date] = []
    @State var tusNotifs: [Date] = []
    @State var wedNotifs: [Date] = []
    @State var thursNotifs: [Date] = []
    @State var friNotifs: [Date] = []
    @State var satNotifs: [Date] = []
    @State var sunNotifs: [Date] = []
    @State var scheduledReminders: [Date] = []
    @State var goodcheckinGoal = 0
    @State var notes = ""
    @State var category = ""
    @State var needTitle = false
    @State var needTracker = false
    @State var needCheckinGoal = false
    @State var needEndDate = false
    static var selectedCat = ""
    static var editGoal = false
    let dateFormatter = DateFormatter()
    
    var body: some View {
        ScrollView {
            Button {
                self.category = ""
                self.notes = ""
                dismiss()
            } label: {
                Image(systemName: "xmark")
            }.frame(maxWidth: UIScreen.main.bounds.width - 60, alignment: .trailing)
                .foregroundColor(Home.accentColor)
                .padding(.top)
            VStack {
                TextField("Title...", text: self.$title, axis: .vertical)
                    .frame(maxWidth: UIScreen.main.bounds.width - 60, minHeight: 70, maxHeight: 5000, alignment: .leading)
                    .font(.system(size: Home.headerFontSize))
                    .foregroundColor(Home.foregroundColor)
                    .background(Home.backgroundColor)
                    .padding(.leading, 20)
                    .overlay(
                        RoundedRectangle(cornerRadius: 15)
                            .stroke(self.needTitle ? .red : Home.accentColor, lineWidth: 2)
                    )
                    .padding(.bottom, 20)
                
                VStack {
                    HStack {
                        Text("Reminders")
                        Image(systemName: "clock")
                    }
                    .foregroundColor(Home.foregroundColor)
                    .font(.system(size: Home.titleFontSize))
                    .frame(maxWidth: UIScreen.main.bounds.width - 30, maxHeight: 55, alignment: .trailing)
                    .onTapGesture {
                        self.remindersTap.toggle()
                        if self.remindersTap == true {
                            self.dailyReminderTap = true
                        }
                    }
                    self.remindersTap ? nil :
                    HStack {
                        Text("Daily")
                        Image(systemName: "clock")
                    }
                    .foregroundColor(Home.foregroundColor)
                    .font(.system(size: Home.fontSize))
                    .frame(maxWidth: UIScreen.main.bounds.width - 30, maxHeight: 65, alignment: .trailing)
                    .onTapGesture {
                        self.dailyReminderTap.toggle()
                    }
                    self.dailyReminderTap ? nil :
                    Group {
                        TimePicker(date: self.$monDate, hidden: self.$monHidden, notifArr: self.$monNotifs, name: "Monday") .animation(.easeInOut, value: self.monHidden)
                        TimePicker(date: self.$tusDate, hidden: self.$tusHidden, notifArr: self.$tusNotifs, name: "Tuesday")
                            .animation(.easeInOut, value: self.tusHidden)
                        TimePicker(date: self.$wedDate, hidden: self.$wedHidden, notifArr: self.$wedNotifs, name: "Wednesday")
                            .animation(.easeInOut, value: self.wedHidden)
                        TimePicker(date: self.$thursDate, hidden: self.$thursHidden, notifArr: self.$thursNotifs, name: "Thursday")
                            .animation(.easeInOut, value: self.thursHidden)
                        TimePicker(date: self.$friDate, hidden: self.$friHidden, notifArr: self.$friNotifs, name: "Friday")
                            .animation(.easeInOut, value: self.friHidden)
                        TimePicker(date: self.$satDate, hidden: self.$satHidden, notifArr: self.$satNotifs, name: "Saturday")
                            .animation(.easeInOut, value: self.satHidden)
                        TimePicker(date: self.$sunDate, hidden: self.$sunHidden, notifArr: self.$sunNotifs, name: "Sunday")
                            .animation(.easeInOut, value: self.sunHidden)
                    }
                    self.remindersTap ? nil :
                    ScheduledReminders(tap: self.$scheduledReminderTap, date: self.$scheduledDate, dates: self.$scheduledReminders)
                }
                .animation(.easeInOut(duration: 1.0), value: self.remindersTap)
                Group {
                    HStack {
                        Text("Progress Tracker")
                            .foregroundColor(Home.foregroundColor)
                            .font(.system(size: Home.titleFontSize))
                        Image(systemName: "chart.line.uptrend.xyaxis")
                            .foregroundColor(Home.foregroundColor)
                            .font(.system(size: Home.titleFontSize))
                    }
                    .frame(maxWidth: UIScreen.main.bounds.width - 30, maxHeight: 65, alignment: .trailing)
                    .padding(.top, 30)
                    .animation(.easeInOut(duration: 1.0), value: self.remindersTap)
                    .onTapGesture {
                        self.progressTrackerTap.toggle()
                    }
                    VStack {
                        self.progressTrackerTap ? nil : ProgressTracker(goodcheckinGoal: self.$goodcheckinGoal, selectedOp: self.$selectedTracker, needCheckinGoal: self.$needCheckinGoal)
                            .frame(height: UIScreen.main.bounds.height / 4)
                            .overlay(
                                RoundedRectangle(cornerRadius: 15)
                                    .stroke(self.needTracker ? .red : .clear, lineWidth: 2)
                            )
                        
                    }.animation(.easeInOut(duration: 1.0), value: self.progressTrackerTap)
                    EndDate(date: self.$endDate, tap: self.$endDateTap, lilTap: self.$lilEndDateTap, hidden: self.$endDateHidden, needEndDate: self.$needEndDate)
                    
                }
                Group {
                    
                    Category(category: self.category)
                    
                    HStack {
                        Text("Notes")
                        Image(systemName: "pencil")
                    }
                    .foregroundColor(Home.foregroundColor)
                    .font(.system(size: Home.titleFontSize))
                    .frame(maxWidth: UIScreen.main.bounds.width - 30, maxHeight: 65, alignment: .trailing)
                    .padding(.top, 20)
                    .padding(.bottom, 20)
                    .onTapGesture {
                        self.notesTap.toggle()
                    }
                    self.notesTap ? nil : ZStack {
                        RoundedRectangle(cornerRadius: 15, style: .continuous)
                            .foregroundColor(Home.accentColor)
                        TextField("Notes...", text: self.$notes, axis: .vertical)
                            .frame(maxWidth: UIScreen.main.bounds.width - 30, minHeight: 120, maxHeight: 5000, alignment: .leading)
                            .font(.system(size: Home.fontSize))
                            .foregroundColor(Home.foregroundColor)
                            .padding(.leading, 20)
                    }
                }
                Button {
                    if checkRequiredFields() == true {
                        EditHabit.editGoal ? update() : create()
                        self.category = ""
                        self.notes = ""
                        dismiss()
                    }
                } label: {
                    Text(EditHabit.editGoal ? "Update" : "Save")
                        .font(.system(size: Home.fontSize))
                        .foregroundColor(Home.foregroundColor)
                }
                .frame(maxWidth: UIScreen.main.bounds.width - 120, alignment: .center)
                .padding(.bottom, EditHabit.editGoal ? 30 : 80)
                .padding(.top, 30)
                EditHabit.editGoal ?
                Button {
                    deleteGoal(goal: currentGoal())
                    self.category = ""
                    self.notes = ""
                    dismiss()
                } label: {
                    Text("Delete")
                        .font(.system(size: Home.fontSize))
                        .foregroundColor(.red)
                        .padding(.bottom, 80)
                }
                : nil
            }
            .frame(maxWidth: UIScreen.main.bounds.width - 30, maxHeight: .infinity, alignment: .trailing)
            .animation(.easeInOut(duration: 1.0), value: dailyReminderTap)
            .animation(.easeInOut(duration: 0.8), value: self.progressTrackerTap)
            .animation(.easeInOut(duration: 0.5), value: self.remindersTap)
            .animation(.easeInOut(duration: 0.5), value: self.scheduledReminderTap)
            .animation(.easeInOut(duration: 0.5), value: endDateTap)
            .animation(.easeInOut(duration: 0.5), value: self.notesTap)
            .padding(.top, 50)
        }.frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .center)
            .accentColor(Home.accentColor)
            .background(Home.backgroundColor)
    }
    func currentGoal()-> Goal {
        let goal = Goal(id: self.id, listID: "", category: EditHabit.selectedCat, title: self.title, dateCreated: self.dateCreated, endDate: self.endDate, goodCheckins: 0, badCheckins: 0, goodCheckinGoal: self.goodcheckinGoal, monNotifs: self.monNotifs, tusNotifs: self.tusNotifs, wedNotifs: self.wedNotifs, thursNotifs: self.thursNotifs, friNotifs: self.friNotifs, satNotifs: self.satNotifs, sunNotifs: self.sunNotifs, scheduledNotifs: self.scheduledReminders, progressTracker: self.selectedTracker, selfNotes: self.notes, prog: self.prog)
        return goal
    }
    
    func update() {
        updateGoal(goal: currentGoal())
        LocalNotificationManager.shared.clearNotifsForUpdate(goal: currentGoal())
        LocalNotificationManager.shared.setDailyNotifs(goal: currentGoal())
        LocalNotificationManager.shared.setScheduledNotifs(goal: currentGoal())
        EditHabit.editGoal = false
    }
    
    func create() {
        createGoal(goal: currentGoal())
        LocalNotificationManager.shared.setDailyNotifs(goal: currentGoal())
        LocalNotificationManager.shared.setScheduledNotifs(goal: currentGoal())
        EditHabit.editGoal = false
    }
    
    func checkRequiredFields()-> Bool {
        var returnBool = true
        self.needTitle = false
        self.needTracker = false
        self.needEndDate = false
        self.needCheckinGoal = false
        if self.title == "" {
            self.needTitle = true
            returnBool = false
        }
        if self.selectedTracker == "" {
            self.needTracker = true
            self.progressTrackerTap = false
            returnBool = false
        }
        if self.selectedTracker == "1" {
            if self.endDate <= Date.now {
                self.needEndDate = true
                self.endDateTap = false
                returnBool = false
            }
            if self.goodcheckinGoal == 0 {
                self.progressTrackerTap = false
                self.needCheckinGoal = true
                returnBool = false
            }
        }
        if self.selectedTracker == "2" {
            if self.goodcheckinGoal == 0 {
                self.progressTrackerTap = false
                self.needCheckinGoal = true
                returnBool = false
            }
        }
        return returnBool
    }
}

struct EditHabit_Previews: PreviewProvider {
    static var previews: some View {
        EditHabit()
    }
}

extension String: Identifiable {
    public var id: String { self }
}

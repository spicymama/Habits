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
    var id: String = ""
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
    @State var notes = ""
    @State var category = ""
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
                .foregroundColor(.gray)
            VStack {
                    TextField("Title...", text: self.$title, axis: .vertical)
                        .frame(maxWidth: UIScreen.main.bounds.width - 60, minHeight: 70, maxHeight: 5000, alignment: .leading)
                        .font(.system(size: 29))
                        .foregroundColor(.gray)
                        .padding(.leading, 20)
                        .overlay(
                        RoundedRectangle(cornerRadius: 15)
                            .stroke(Color(UIColor.systemGray3), lineWidth: 2)
                        )
                        .padding(.bottom, 20)
              
                VStack {
                    HStack {
                        Text("Reminders")
                        Image(systemName: "clock")
                    }
                    .foregroundColor(.gray)
                    .font(.system(size: 35))
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
                    .foregroundColor(.gray)
                    .font(.system(size: 25))
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
                            .foregroundColor(.gray)
                            .font(.system(size: 35))
                        Image(systemName: "chart.line.uptrend.xyaxis")
                            .foregroundColor(.gray)
                            .font(.system(size: 30))
                    }
                    .frame(maxWidth: UIScreen.main.bounds.width - 30, maxHeight: 65, alignment: .trailing)
                    .padding(.top, 30)
                    .animation(.easeInOut(duration: 1.0), value: self.remindersTap)
                    .onTapGesture {
                        self.progressTrackerTap.toggle()
                    }
                    VStack {
                        self.progressTrackerTap ? nil : ProgressTracker(selectedOp: self.$selectedTracker)
                            .frame(height: UIScreen.main.bounds.height / 3)
                    }.animation(.easeInOut(duration: 1.0), value: self.progressTrackerTap)
                    Text(self.selectedTracker)
                        .foregroundColor(.gray)
                        .font(.system(size: 12))
                        .frame(maxWidth: UIScreen.main.bounds.width - 20, alignment: .trailing)
                    EndDate(date: self.$endDate, tap: self.$endDateTap, lilTap: self.$lilEndDateTap, hidden: self.$endDateHidden)
                }
                Group {
                    
                    Category(category: self.category)
                    
                    HStack {
                        Text("Notes")
                        Image(systemName: "pencil")
                    }
                    .foregroundColor(.gray)
                    .font(.system(size: 35))
                    .frame(maxWidth: UIScreen.main.bounds.width - 30, maxHeight: 65, alignment: .trailing)
                    .padding(.top, 20)
                    .padding(.bottom, 20)
                    .onTapGesture {
                        self.notesTap.toggle()
                    }
                    self.notesTap ? nil : ZStack {
                        RoundedRectangle(cornerRadius: 15, style: .continuous)
                            .foregroundColor(Color(UIColor.systemGray5))
                        TextField("Notes...", text: self.$notes, axis: .vertical)
                            .frame(maxWidth: UIScreen.main.bounds.width - 30, minHeight: 120, maxHeight: 5000, alignment: .leading)
                            .font(.system(size: 18))
                            .foregroundColor(Color(UIColor.gray))
                            .padding(.leading, 20)
                    }
                }
                Button {
                    EditHabit.editGoal ?  updateGoal(goal: Goal(id: self.id, category: EditHabit.selectedCat, title: self.title, dateCreated: self.dateCreated, endDate: self.endDate, goodCheckins: 0, badCheckins: 0, monNotifs: self.monNotifs, tusNotifs: self.tusNotifs, wedNotifs: self.wedNotifs, thursNotifs: self.thursNotifs, friNotifs: self.friNotifs, satNotifs: self.satNotifs, sunNotifs: self.sunNotifs, scheduledNotifs: self.scheduledReminders, progressTracker: self.selectedTracker, selfNotes: self.notes, prog: self.prog)) :
                    createGoal(goal: Goal(id: UUID().uuidString,  category: EditHabit.selectedCat, title: self.title, dateCreated: self.dateCreated, endDate: self.endDate, goodCheckins: 0, badCheckins: 0, monNotifs: self.monNotifs, tusNotifs: self.tusNotifs, wedNotifs: self.wedNotifs, thursNotifs: self.thursNotifs, friNotifs: self.friNotifs, satNotifs: self.satNotifs, sunNotifs: self.sunNotifs, scheduledNotifs: self.scheduledReminders, progressTracker: self.selectedTracker, selfNotes: self.notes, prog: self.prog))
              
                    LocalNotificationManager.shared.setDailyNotifs(goal: Goal(id: UUID().uuidString,  category: EditHabit.selectedCat, title: self.title, dateCreated: self.dateCreated, endDate: self.endDate, goodCheckins: 0, badCheckins: 0, monNotifs: self.monNotifs, tusNotifs: self.tusNotifs, wedNotifs: self.wedNotifs, thursNotifs: self.thursNotifs, friNotifs: self.friNotifs, satNotifs: self.satNotifs, sunNotifs: self.sunNotifs, scheduledNotifs: self.scheduledReminders, progressTracker: self.selectedTracker, selfNotes: self.notes, prog: self.prog))
                    /* 
                    for date in scheduledReminders {
                        notificationManager.scheduleNotification(sendDate: date, goal: Goal(id: UUID().uuidString,  category: EditHabit.selectedCat, title: self.title, dateCreated: self.dateCreated, endDate: self.endDate, goodCheckins: 0, badCheckins: 0, monNotifs: self.monNotifs, tusNotifs: self.tusNotifs, wedNotifs: self.wedNotifs, thursNotifs: self.thursNotifs, friNotifs: self.friNotifs, satNotifs: self.satNotifs, sunNotifs: self.sunNotifs, scheduledNotifs: self.scheduledReminders, progressTracker: self.selectedTracker, selfNotes: self.notes, prog: self.prog), weekday: 0)
                    }
                    */
                    EditHabit.editGoal.toggle()
                    self.category = ""
                    self.notes = ""
                    dismiss()
                } label: {
                    Text(EditHabit.editGoal ? "Update" : "Save")
                        .font(.system(size: 20))
                        .foregroundColor(.gray)
                }
                .frame(maxWidth: UIScreen.main.bounds.width - 120, alignment: .center)
                .padding(.bottom, 30)
                .padding(.top, 30)
            EditHabit.editGoal ?
                Button {
                    deleteGoal(goal: Goal(id: self.id, category: EditHabit.selectedCat, title: self.title, dateCreated: self.dateCreated, endDate: self.endDate, goodCheckins: 0, badCheckins: 0,monNotifs: self.monNotifs, tusNotifs: self.tusNotifs, wedNotifs: self.wedNotifs, thursNotifs: self.thursNotifs, friNotifs: self.friNotifs, satNotifs: self.satNotifs, sunNotifs: self.sunNotifs, scheduledNotifs: self.scheduledReminders, progressTracker: self.selectedTracker, selfNotes: self.notes, prog: self.prog))
                    EditHabit.editGoal.toggle()
                    self.category = ""
                    self.notes = ""
                    dismiss()
                } label: {
                    Text("Delete")
                        .font(.system(size: 20))
                        .foregroundColor(.red)
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
        }.frame(maxWidth: UIScreen.main.bounds.width - 20, maxHeight: .infinity, alignment: .center)
            .accentColor(/*@START_MENU_TOKEN@*/.gray/*@END_MENU_TOKEN@*/)
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


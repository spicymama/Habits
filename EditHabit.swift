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
    @State var dailyNotifs: [Date] = []
    @State var scheduledReminders: [Date] = []
    @State var notes = ""
    @State var category = "Category"
    static var editGoal = false
    let dateFormatter = DateFormatter()
    
    var body: some View {
        ScrollView {
            Button {
                dismiss()
            } label: {
                Image(systemName: "xmark")
            }.frame(maxWidth: UIScreen.main.bounds.width - 60, alignment: .trailing)
                .foregroundColor(.gray)
            VStack {
                    TextField("Title...", text: self.$title, axis: .vertical)
                        .frame(maxWidth: UIScreen.main.bounds.width - 30, minHeight: 100, maxHeight: 5000, alignment: .topLeading)
                        .font(.system(size: 29))
                        .foregroundColor(.gray)
                        .padding(.leading, 20)
              
                VStack {
                    HStack {
                        Text("Reminders")
                            .foregroundColor(.gray)
                            .font(.system(size: 35))
                        Image(systemName: "clock")
                            .foregroundColor(.gray)
                            .font(.system(size: 30))
                    }
                    .frame(maxWidth: UIScreen.main.bounds.width - 30, maxHeight: 65, alignment: .trailing)
                    .onTapGesture {
                        self.remindersTap.toggle()
                        if self.remindersTap == true {
                            self.dailyReminderTap = true
                        }
                    }
                    self.remindersTap ? nil :
                    HStack {
                        Text("Daily")
                            .foregroundColor(.gray)
                            .font(.system(size: 25))
                        Image(systemName: "clock")
                            .foregroundColor(.gray)
                            .font(.system(size: 24))
                    }
                    .frame(maxWidth: UIScreen.main.bounds.width - 30, maxHeight: 65, alignment: .trailing)
                    .onTapGesture {
                        self.dailyReminderTap.toggle()
                    }
                    self.dailyReminderTap ? nil :
                    Group {
                        TimePicker(date: self.$monDate, reminders: findDay(day: 2), hidden: self.$monHidden, name: "Monday") .animation(.easeInOut, value: self.monHidden)
                        TimePicker(date: self.$tusDate, reminders: findDay(day: 3), hidden: self.$tusHidden, name: "Tuesday")
                            .animation(.easeInOut, value: self.tusHidden)
                        TimePicker(date: self.$wedDate, reminders: findDay(day: 4), hidden: self.$wedHidden, name: "Wednesday")
                            .animation(.easeInOut, value: self.wedHidden)
                        TimePicker(date: self.$thursDate, reminders: findDay(day: 5), hidden: self.$thursHidden, name: "Thursday")
                            .animation(.easeInOut, value: self.thursHidden)
                        TimePicker(date: self.$friDate, reminders: findDay(day: 6), hidden: self.$friHidden, name: "Friday")
                            .animation(.easeInOut, value: self.friHidden)
                        TimePicker(date: self.$satDate, reminders: findDay(day: 7), hidden: self.$satHidden, name: "Saturday")
                            .animation(.easeInOut, value: self.satHidden)
                        TimePicker(date: self.$sunDate, reminders: findDay(day: 1), hidden: self.$sunHidden, name: "Sunday")
                            .animation(.easeInOut, value: self.sunHidden)
                    }
                    self.remindersTap ? nil :
                    ScheduledReminders(tap: self.$scheduledReminderTap, date: self.$scheduledDate, dates: self.$scheduledReminders)
                }
                .animation(.easeInOut(duration: 1.0), value: self.remindersTap)
               
                HStack {
                    Text("Progress Tracker")
                        .foregroundColor(.gray)
                        .font(.system(size: 35))
                    Image(systemName: "chart.line.uptrend.xyaxis")
                        .foregroundColor(.gray)
                        .font(.system(size: 30))
                }
                .frame(maxWidth: UIScreen.main.bounds.width - 30, maxHeight: 65, alignment: .trailing)
                .padding(.top, 45)
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
                VStack {
                    HStack {
                        Text("End Date")
                            .foregroundColor(.gray)
                            .font(.system(size: 35))
                        Image(systemName: "calendar")
                            .foregroundColor(.gray)
                            .font(.system(size: 30))
                    }
                    .frame(maxWidth: UIScreen.main.bounds.width - 30, maxHeight: 65, alignment: .trailing)
                    .padding(.top, 45)
                    .padding(.bottom, 10)
                    .onTapGesture {
                        self.endDateTap.toggle()
                    }
                    HStack {
                        self.endDateTap ? nil :  DatePicker(selection: self.$endDate) {
                            Image(systemName: "calendar")
                        }.labelsHidden()
                            .colorScheme(.dark)
                        self.endDateTap ? nil :
                        Button {
                            self.endDateTap.toggle()
                            self.endDateHidden = false
                        } label: {
                            Image(systemName: "plus")
                                .foregroundColor(.gray)
                        }
                    }
                    .frame(maxWidth: UIScreen.main.bounds.width - 30, alignment: .trailing)
                    HStack {
                        self.endDateHidden ? nil :
                        Text(showEndDate())
                            .foregroundColor(.gray)
                            .font(.system(size: 12))
                            .frame(maxWidth: UIScreen.main.bounds.width - 30, alignment: .trailing)
                            .onTapGesture(perform: {
                                self.lilEndDateTap.toggle()
                            })
                        self.lilEndDateTap ? nil :
                        Button {
                            self.endDate = Date.distantPast
                            self.endDateHidden.toggle()
                            self.lilEndDateTap.toggle()
                        } label: {
                            Image(systemName: "xmark.circle")
                                .font(.system(size: 12))
                        }.padding(.trailing, 10)
                    }.animation(.easeInOut, value: self.lilEndDateTap)
                }
                HStack {
                    Text("Notes")
                        .foregroundColor(.gray)
                        .font(.system(size: 35))
                    Image(systemName: "pencil")
                        .foregroundColor(.gray)
                        .font(.system(size: 30))
                }
                .frame(maxWidth: UIScreen.main.bounds.width - 30, maxHeight: 65, alignment: .trailing)
                .padding(.top, 45)
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
                Button {
                    EditHabit.editGoal ?  updateGoal(goal: Goal(id: self.id, category: self.category, title: self.title, dateCreated: self.dateCreated, endDate: self.endDate, dailyNotifs: self.dailyNotifs, scheduledNotifs: self.scheduledReminders, progressTracker: self.selectedTracker, selfNotes: self.notes, prog: self.prog)) :
                    createGoal(goal: Goal(id: UUID().uuidString, category: self.category, title: self.title, dateCreated: Date.now, endDate: self.endDate, dailyNotifs: self.dailyNotifs, scheduledNotifs: self.scheduledReminders, progressTracker: self.selectedTracker, selfNotes: self.notes, prog: self.prog))
                    
                    EditHabit.editGoal.toggle()
                    dismiss()
                } label: {
                    Text(EditHabit.editGoal ? "Update" : "Save")
                        .font(.system(size: 20))
                        .foregroundColor(.gray)
                }
                .frame(maxWidth: UIScreen.main.bounds.width - 120, alignment: .center)
                .padding(.bottom, 80)
                .padding(.top, 50)
            EditHabit.editGoal ?
                Button {
                    deleteGoal(goal: Goal(id: self.id, category: self.category, title: self.title, dateCreated: Date.now, endDate: self.endDate, dailyNotifs: self.dailyNotifs, scheduledNotifs: self.scheduledReminders, progressTracker: self.selectedTracker, selfNotes: self.notes, prog: self.prog))
                    EditHabit.editGoal.toggle()
                    dismiss()
                } label: {
                    Text("Delete")
                        .font(.system(size: 20))
                        .foregroundColor(.red)
                }
                : nil
            }
            .frame(maxWidth: UIScreen.main.bounds.width - 30, maxHeight: .infinity, alignment: .trailing)
            .animation(.easeInOut(duration: 1.5), value: dailyReminderTap)
            .animation(.easeInOut(duration: 1.0), value: self.progressTrackerTap)
            .animation(.easeInOut(duration: 1.0), value: self.remindersTap)
            .animation(.easeInOut(duration: 1.0), value: self.scheduledReminderTap)
            .animation(.easeInOut(duration: 1.0), value: endDateTap)
            .animation(.easeInOut(duration: 1.0), value: self.notesTap)
            .padding(.top, 50)
        }.frame(maxWidth: UIScreen.main.bounds.width - 20, maxHeight: .infinity, alignment: .center)
            .accentColor(/*@START_MENU_TOKEN@*/.gray/*@END_MENU_TOKEN@*/)
    }
    func showEndDate()-> String {
        dateFormatter.dateStyle = .short
        return dateFormatter.string(from: endDate)
    }
    func findDay(day: Int)-> [Date] {
        //Sunday = 1
        var dateArr: [Date] = []
        for i in dailyNotifs {
            print("DATE: \(i) \n DayVar: \(day) \n DayNUM: \(String(describing: i.dayNumberOfWeek()))")
            if i.dayNumberOfWeek() == day {
                dateArr.append(i)
            }
        }
       return dateArr
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


//
//  EditHabit.swift
//  Habits
//
//  Created by Gavin Woffinden on 11/29/22.
//

import SwiftUI

struct EditHabit: View {
    static var shared = EditHabit()
    @State var title = ""
    @State var endDateTap = true
    @State var remindersTap = true
    @State var dailyReminderTap = true
    @State var scheduledReminderTap = true
    @State var progressTrackerTap = true
    @State var selectedTracker = ""
  //  @State var op1Tap = false
  //  @State var op2Tap = false
   // @State var op3Tap = false
   // @State var op4Tap = false
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
    @State var monReminders: [Date] = []
    @State var tusReminders: [Date] = []
    @State var wedReminders: [Date] = []
    @State var thursReminders: [Date] = []
    @State var friReminders: [Date] = []
    @State var satReminders: [Date] = []
    @State var sunReminders: [Date] = []
    @State var scheduledReminders: [Date] = []
    let dateFormatter = DateFormatter()
    
    var body: some View {
        ScrollView {
            VStack {
                TextField("Title...", text: self.$title)
                    .frame(maxWidth: UIScreen.main.bounds.width - 30, maxHeight: 65, alignment: .topLeading)
                    .font(.system(size: 29))
                    .padding(.leading, 20)
                VStack {
                    HStack {
                        Text("Reminders")
                            .foregroundColor(.gray)
                            .font(.system(size: 25))
                        Button {
                            self.remindersTap.toggle()
                            if self.remindersTap == true {
                                self.dailyReminderTap = true
                            }
                        } label: {
                            Image(systemName: "clock")
                                .foregroundColor(.gray)
                        }
                    }
                    .frame(maxWidth: UIScreen.main.bounds.width - 30, maxHeight: 65, alignment: .trailing)
                    .padding(.top, 45)
                    self.remindersTap ? nil :
                    HStack {
                        Text("Daily")
                            .foregroundColor(.gray)
                            .font(.system(size: 18))
                        Button {
                            self.dailyReminderTap.toggle()
                        } label: {
                            Image(systemName: "clock")
                                .foregroundColor(.gray)
                        }
                    }
                    .frame(maxWidth: UIScreen.main.bounds.width - 30, maxHeight: 65, alignment: .trailing)
                    self.dailyReminderTap ? nil :
                    Group {
                        TimePicker(date: self.$monDate, reminders: self.$monReminders, hidden: self.$monHidden, name: "Monday")
                        TimePicker(date: self.$tusDate, reminders: self.$tusReminders, hidden: self.$tusHidden, name: "Tuesday")
                        TimePicker(date: self.$wedDate, reminders: self.$wedReminders, hidden: self.$wedHidden, name: "Wednesday")
                        TimePicker(date: self.$thursDate, reminders: self.$thursReminders, hidden: self.$thursHidden, name: "Thursday")
                        TimePicker(date: self.$friDate, reminders: self.$friReminders, hidden: self.$friHidden, name: "Friday")
                        TimePicker(date: self.$satDate, reminders: self.$satReminders, hidden: self.$satHidden, name: "Saturday")
                        TimePicker(date: self.$sunDate, reminders: self.$sunReminders, hidden: self.$sunHidden, name: "Sunday")
                    }
                    self.remindersTap ? nil :
                    ScheduledReminders(tap: self.$scheduledReminderTap, date: self.$scheduledDate, dates: self.$scheduledReminders)
         
                }.animation(.easeInOut(duration: 1.0), value: self.remindersTap)
                HStack {
                    Text("Progress Tracker")
                        .foregroundColor(.gray)
                        .font(.system(size: 25))
                    Image(systemName: "chart.line.uptrend.xyaxis")
                        .foregroundColor(.gray)
                }
                .frame(maxWidth: UIScreen.main.bounds.width - 30, maxHeight: 65, alignment: .trailing)
                .padding(.top, 45)
                .onTapGesture {
                    self.progressTrackerTap.toggle()
                }
                VStack {
                    self.progressTrackerTap ? nil : ProgressTracker(selectedOp: self.$selectedTracker)
                }.animation(.easeInOut(duration: 1.0), value: self.progressTrackerTap)
                Text(self.selectedTracker)
                    .foregroundColor(.gray)
                    .font(.system(size: 12))
                    .frame(maxWidth: UIScreen.main.bounds.width - 20, alignment: .trailing)
                VStack {
                    HStack {
                        Text("End Date")
                            .foregroundColor(.gray)
                            .font(.system(size: 25))
                        Button {
                            self.endDateTap.toggle()
                        } label: {
                           Image(systemName: "calendar")
                                .foregroundColor(.gray)
                        }
                        
                        
                      
                    }
                    .frame(maxWidth: UIScreen.main.bounds.width - 30, maxHeight: 65, alignment: .trailing)
                    .padding(.top, 45)
                    .padding(.bottom, 10)
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
                    self.endDateHidden ? nil :
                    Text(showEndDate())
                        .foregroundColor(.gray)
                        .font(.system(size: 12))
                        .frame(maxWidth: UIScreen.main.bounds.width - 30, alignment: .trailing)
                }.animation(.easeInOut(duration: 1.0), value: endDateTap)
              
            }
            .frame(maxWidth: UIScreen.main.bounds.width - 30, maxHeight: 5000, alignment: .trailing)
            .animation(.easeInOut(duration: 1.5), value: dailyReminderTap)
            .padding(.top, 100)
        }.frame(maxWidth: UIScreen.main.bounds.width - 20, maxHeight: UIScreen.main.bounds.height, alignment: .center)
            .accentColor(/*@START_MENU_TOKEN@*/.gray/*@END_MENU_TOKEN@*/)
    }
    func showEndDate()-> String {
        dateFormatter.dateStyle = .short
        return dateFormatter.string(from: endDate)
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


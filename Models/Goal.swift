//
//  Goal.swift
//  Habits
//
//  Created by Gavin Woffinden on 11/14/22.
//

import Foundation
import SwiftUI

struct Goal: View, Identifiable {
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
    @State var selfNotes: String = ""
    @State var prog: Double = 0.0
    @State var editGoalTap = false
    @State private var isEditing = false

  
    var body: some View {
        VStack {
            HStack {
                Text(self.title)
                    .font(.system(size: 25))
                    .foregroundColor(.gray)
            }
            .frame(maxWidth: UIScreen.main.bounds.width - 20, maxHeight: 50, alignment: .leading)
            .padding(.bottom, 10)
            .padding(.leading, 40)
            HStack {
                Image(systemName: checkDay(day: 2) ? "m.circle" : "m.circle.fill")
                Image(systemName: checkDay(day: 3) ? "t.circle" : "t.circle.fill")
                Image(systemName: checkDay(day: 4) ? "w.circle" : "w.circle.fill")
                Image(systemName: checkDay(day: 5) ? "t.circle" : "t.circle.fill")
                Image(systemName: checkDay(day: 6) ? "f.circle" : "f.circle.fill")
                Image(systemName: checkDay(day: 7) ? "s.circle" : "s.circle.fill")
                Image(systemName: checkDay(day: 1) ? "s.circle" : "s.circle.fill")
            }  .frame(maxWidth: UIScreen.main.bounds.width - 40, maxHeight: 50, alignment: .leading)
                .padding(.leading, 25)
                .padding(.bottom, 10)
                .foregroundColor(.gray)
            HStack {
                Slider(value: self.$prog,
                    in: 0...100,
                    onEditingChanged: { editing in
                      isEditing = editing
                }
                ).allowsHitTesting(self.progressTracker == "Manually track my progress" ? true : false)
                Text("\(self.prog, specifier: "%.0f") %")
                    .foregroundColor(.gray)
                    .padding(.leading)
            }
                .frame(maxWidth: UIScreen.main.bounds.width - 70, alignment: .leading)
                .padding(.bottom, 10)
                .accentColor(.gray)
            TextField("Notes:", text: self.$selfNotes, axis: .vertical)
                .frame(maxWidth: UIScreen.main.bounds.width - 70, maxHeight: .infinity, alignment: .topLeading)
                .lineLimit(100)
                .foregroundColor(.gray)
            Button {
                EditHabit.shared.title = self.title
                self.editGoalTap = true
                EditHabit.editGoal = true
            } label: {
                Image(systemName: "chevron.right.circle")
                    .foregroundColor(.gray)
                    .imageScale(.large)
            }.frame(maxWidth: 20, maxHeight: 20, alignment: .topTrailing)
            .padding(.bottom, 20)
            .padding(.leading, UIScreen.main.bounds.width / 1.5)
            .fullScreenCover(isPresented: self.$editGoalTap) {
                EditHabit(id: self.id, prog: self.prog, dateCreated: self.dateCreated, title: self.title, selectedTracker: self.progressTracker, endDate: self.endDate, dailyNotifs: self.dailyNotifs, scheduledReminders: self.scheduledNotifs, notes: self.selfNotes, category: self.category)
            }
        }
    }
    func checkDay(day: Int)-> Bool {
        for i in dailyNotifs {
            print("DATE: \(i) \n DayVar: \(day) \n DayNUM: \(String(describing: i.dayNumberOfWeek()))")
            if i.dayNumberOfWeek() == day {
                return false
            }
        }
        return true
    }
}

struct Goal_Previews: PreviewProvider {
    static var previews: some View {
        Goal(category: "Category", title: "Title", dateCreated: Date.now, endDate: Date.distantFuture, scheduledNotifs: [Date.now, Date.distantFuture], selfNotes: "Hello", prog: 28.0)
    }
}
extension Double {
    var noDecimal: String {
        return self.truncatingRemainder(dividingBy: 1) == 0 ? String(format: "%.0f", self) : String(self)
    }
}
extension Date {
    func dayNumberOfWeek() -> Int? {
        return Calendar.current.dateComponents([.weekday], from: self).weekday
    }
}
/*, Goal(category: "Habits to Get", title: "Sdand up straight", dateCreated: Date.now, endDate: Date.now + 3, goodCheckins: 3, badCheckins: 2, notificationTimes: [Date.now], selfNotes: "This is not that easy"), Goal(category: "Habits to Get", title: "Workout 3 times a week", dateCreated: Date.now, endDate: Date.now + 50, goodCheckins: 9, badCheckins: 3, notificationTimes: [Date.now], selfNotes: "Gonna get so big and strong"), Goal(category: "Habits to Get", title: "Sdand up straight", dateCreated: Date.now, endDate: Date.now + 3, goodCheckins: 3, badCheckins: 2, notificationTimes: [Date.now], selfNotes: "This is not that easy"), Goal(category: "Habits to Get", title: "Workout 3 times a week", dateCreated: Date.now, endDate: Date.now + 50, goodCheckins: 9, badCheckins: 3, notificationTimes: [Date.now], selfNotes: "Gonna get so big and strong"), Goal(category: "Habits to Get", title: "Sdand up straight", dateCreated: Date.now, endDate: Date.now + 3, goodCheckins: 3, badCheckins: 2, notificationTimes: [Date.now], selfNotes: "This is not that easy"), Goal(category: "Habits to Get", title: "Workout 3 times a week", dateCreated: Date.now, endDate: Date.now + 50, goodCheckins: 9, badCheckins: 3, notificationTimes: [Date.now], selfNotes: "Gonna get so big and strong"), Goal(category: "Habits to Get", title: "Sdand up straight", dateCreated: Date.now, endDate: Date.now + 3, goodCheckins: 3, badCheckins: 2, notificationTimes: [Date.now], selfNotes: "This is not that easy"), Goal(category: "Habits to Get", title: "Workout 3 times a week", dateCreated: Date.now, endDate: Date.now + 50, goodCheckins: 9, badCheckins: 3, notificationTimes: [Date.now], selfNotes: "Gonna get so big and strong"), Goal(category: "Habits to Get", title: "Sdand up straight", dateCreated: Date.now, endDate: Date.now + 3, goodCheckins: 3, badCheckins: 2, notificationTimes: [Date.now], selfNotes: "This is not that easy"), Goal(category: "Habits to Get", title: "Workout 3 times a week", dateCreated: Date.now, endDate: Date.now + 50, goodCheckins: 9, badCheckins: 3, notificationTimes: [Date.now], selfNotes: "Gonna get so big and strong"), Goal(category: "Habits to Get", title: "Sdand up straight", dateCreated: Date.now, endDate: Date.now + 3, goodCheckins: 3, badCheckins: 2, notificationTimes: [Date.now], selfNotes: "This is not that easy"), Goal(category: "Habits to Get", title: "Workout 3 times a week", dateCreated: Date.now, endDate: Date.now + 50, goodCheckins: 9, badCheckins: 3, notificationTimes: [Date.now], selfNotes: "Gonna get so big and strong"), Goal(category: "Habits to Get", title: "Sdand up straight", dateCreated: Date.now, endDate: Date.now + 3, goodCheckins: 3, badCheckins: 2, notificationTimes: [Date.now], selfNotes: "This is not that easy"), Goal(category: "Habits to Get", title: "Workout 3 times a week", dateCreated: Date.now, endDate: Date.now + 50, goodCheckins: 9, badCheckins: 3, notificationTimes: [Date.now], selfNotes: "Gonna get so big and strong")*/


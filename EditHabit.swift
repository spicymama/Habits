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
    @State var calendarTap = false
    @State var monDate = Date.now
    @State var tusDate = Date.now
    @State var wedDate = Date.now
    @State var thursDate = Date.now
    @State var friDate = Date.now
    @State var satDate = Date.now
    @State var sunDate = Date.now
    @State var monHidden = true
    @State var tusHidden = true
    @State var wedHidden = true
    @State var thursHidden = true
    @State var friHidden = true
    @State var satHidden = true
    @State var sunHidden = true
    @State var monReminders: [Date] = []
    @State var tusReminders: [Date] = []
    @State var wedReminders: [Date] = []
    @State var thursReminders: [Date] = []
    @State var friReminders: [Date] = []
    @State var satReminders: [Date] = []
    @State var sunReminders: [Date] = []
    
    var body: some View {
        
        VStack {
            TextField("Title...", text: self.$title)
                .frame(maxWidth: UIScreen.main.bounds.width - 30, maxHeight: 65, alignment: .topLeading)
                .font(.system(size: 29))
            HStack {
                Text("Reminders")
                Button {
                    self.calendarTap.toggle()
                } label: {
                    Image(systemName: "clock")
                        .foregroundColor(.black)
                }

            }
            .frame(maxWidth: UIScreen.main.bounds.width - 30, maxHeight: 65, alignment: .leading)
            TimePicker(date: self.$monDate, reminders: self.$monReminders, hidden: self.$monHidden, name: "Monday")
            TimePicker(date: self.$tusDate, reminders: self.$tusReminders, hidden: self.$tusHidden, name: "Tuesday")
            TimePicker(date: self.$wedDate, reminders: self.$wedReminders, hidden: self.$wedHidden, name: "Wednesday")
            TimePicker(date: self.$thursDate, reminders: self.$thursReminders, hidden: self.$thursHidden, name: "Thursday")
            TimePicker(date: self.$friDate, reminders: self.$friReminders, hidden: self.$friHidden, name: "Friday")
            TimePicker(date: self.$satDate, reminders: self.$satReminders, hidden: self.$satHidden, name: "Saturday")
            TimePicker(date: self.$sunDate, reminders: self.$sunReminders, hidden: self.$sunHidden, name: "Sunday")
            
            HStack {
                Text("End Date")
                Button {
                    self.calendarTap.toggle()
                } label: {
                    Image(systemName: "calendar")
                        .foregroundColor(.black)
                }

            }
            .frame(maxWidth: UIScreen.main.bounds.width - 30, maxHeight: 65, alignment: .leading)
            

        }
        .frame(maxWidth: UIScreen.main.bounds.width - 30, maxHeight: 5000, alignment: .leading)
    }
}
func showSelectedTimes(dates: [Date]) -> [String] {
    let timeFormatter = DateFormatter()
    var timeArr: [String] = [""]
    for date in dates.sorted(by: { $0.compare($1) == .orderedAscending }) {
        timeFormatter.timeStyle = .short
        timeArr.append(timeFormatter.string(from: date))
    }
    return timeArr
}

struct EditHabit_Previews: PreviewProvider {
    static var previews: some View {
        EditHabit()
    }
}

extension String: Identifiable {
    public var id: String { self }
}

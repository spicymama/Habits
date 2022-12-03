//
//  ScheduledReminders.swift
//  Habits
//
//  Created by Gavin Woffinden on 12/2/22.
//

import SwiftUI

struct ScheduledReminders: View {
    @Binding var tap: Bool
    @Binding var date: Date
    @Binding var dates: [Date]
    var body: some View {
        VStack {
            HStack {
                Text("Scheduled Reminders")
                    .foregroundColor(.gray)
                    .font(.system(size: 25))
                Image(systemName: "calendar")
                        .foregroundColor(.gray)
                        .font(.system(size: 24))
            }
            .frame(maxWidth: UIScreen.main.bounds.width - 30, maxHeight: 65, alignment: .trailing)
            .onTapGesture {
                self.tap.toggle()
            }
            HStack {
                self.tap ? nil :  DatePicker(selection: self.$date) {
                    Image(systemName: "calendar")
                }
                    .accentColor(.white)
                    .labelsHidden()
                    .colorScheme(.dark)
                self.tap ? nil : Button {
                    if self.tap == true {
                        self.tap.toggle()
                    } else {
                        if !self.dates.contains(self.date) {
                            self.dates.append(self.date)
                        }
                    }
                } label: {
                    Image(systemName: "plus")
                        .foregroundColor(.gray)
                        .imageScale(.medium)
                }
            } .frame(maxWidth: UIScreen.main.bounds.width - 30, maxHeight: 65, alignment: .trailing)
            HStack {
                ForEach(showSelectedDates(dates: self.dates, dateStyle: .short)) { time in
                    Text(time)
                        .foregroundColor(.gray)
                        .font(.system(size: 12))
                }
                .padding(.trailing, 5)
            }
            .frame(maxWidth: UIScreen.main.bounds.width - 20, alignment: .trailing)
        }
        .animation(.easeInOut(duration: 1.0), value: tap)
    }
}

struct ScheduledReminders_Previews: PreviewProvider {
    static var previews: some View {
        ScheduledReminders(tap: EditHabit.shared.$scheduledReminderTap, date: EditHabit.shared.$scheduledDate, dates: EditHabit.shared.$scheduledReminders)
    }
}
